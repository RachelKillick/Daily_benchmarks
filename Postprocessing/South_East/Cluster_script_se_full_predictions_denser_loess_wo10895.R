# Hopefully verging on my final model for SE

# Load the necessary packages first:

library(mgcv)
library(akima)
library(fields)

# Load the necessary dataframes and other R things:

load('loesssurf1.RData') 
load('SEcoast1reloc_1714.RData') 
load('preds_se_11714_denser_full.RData')

# Want to look at correlations of predictions before and after deseasonalisation:

# Create a data frame to store values in

newup=SEcoast1reloc
rm(SEcoast1reloc) # Because I don't want a MASSIVE dataframe in the work space twice!

newup$pred5th1=60-pred5th1
newup$pred5th1gama=pred5th1gama[,1]-pred5th1
newup$pred5th1gamb=pred5th1gamb[,1]-pred5th1

rm(pred5th1gama,pred5th1gamb)

newup=newup[newup$Station!=108,]
newup=newup[newup$Station!=156,]

day1170=newup[newup$Time==1,]

call1=as.matrix(cbind(day1170$Lat,day1170$Long))

# Want to be able to get the geographically closest stations in the smoothing, not just the ones R thinks are closest => use the rdist command to work out the distances East and North of the most southwesterly point of the region (-90.1,25) (this has been altered slightly for the more dense network)

lon=rdist.earth(cbind(call1[,2],rep(25,420)),cbind(-90.1,25),miles=FALSE)
lat=rdist.earth(cbind(rep(-90.1,420),call1[,1]),cbind(-90.1,25),miles=FALSE)

call1=cbind(lon,lat) 

lsmodel40a=data.frame(matrix(ncol=2,nrow=6442800)) 
lsmodel45a=data.frame(matrix(ncol=2,nrow=6442800)) 
lsmodel40b=data.frame(matrix(ncol=2,nrow=6442800)) 
lsmodel45b=data.frame(matrix(ncol=2,nrow=6442800)) 

ls40=40/420
ls45=45/420

# Look at creating the loess smoothed versions of the errors:

for (j in 1:15340){
	day=newup[newup$Time==j,]
	namemodel40a=loess.surf1(day$pred5th1gama,call1,degree=2,span=ls40)
	namemodel45a=loess.surf1(day$pred5th1gama,call1,degree=2,span=ls45)
	namemodel40b=loess.surf1(day$pred5th1gamb,call1,degree=2,span=ls40)
	namemodel45b=loess.surf1(day$pred5th1gamb,call1,degree=2,span=ls45)

	j1=420*(j-1)+1
	j2=420*j
	lsmodel40a[j1:j2,1]=seq(1,420)
	lsmodel40a[j1:j2,2]=namemodel40a
	lsmodel45a[j1:j2,1]=seq(1,420)
	lsmodel45a[j1:j2,2]=namemodel45a
	lsmodel40b[j1:j2,1]=seq(1,420)
	lsmodel40b[j1:j2,2]=namemodel40b
	lsmodel45b[j1:j2,1]=seq(1,420)
	lsmodel45b[j1:j2,2]=namemodel45b
}

lsmodel40aa=lsmodel40a[with(lsmodel40a, order(lsmodel40a[,1])), ]
lsmodel40ca=lsmodel40aa[,2]
lsmodel45aa=lsmodel45a[with(lsmodel45a, order(lsmodel45a[,1])), ]
lsmodel45ca=lsmodel45aa[,2]
lsmodel40ab=lsmodel40b[with(lsmodel40b, order(lsmodel40b[,1])), ]
lsmodel40cb=lsmodel40ab[,2]
lsmodel45ab=lsmodel45b[with(lsmodel45b, order(lsmodel45b[,1])), ]
lsmodel45cb=lsmodel45ab[,2]

save(lsmodel40ca,lsmodel45ca,lsmodel40cb,lsmodel45cb,file='loessmodel_se_comp_201014_relocations_full_denser_loess_wo108156.RData')

newup$lsmodel40a=60-(lsmodel40ca+(60-newup$pred5th1))
newup$lsmodel45a=60-(lsmodel45ca+(60-newup$pred5th1))
newup$lsmodel40b=60-(lsmodel40cb+(60-newup$pred5th1))
newup$lsmodel45b=60-(lsmodel45cb+(60-newup$pred5th1))

save(newup,file='newup_se_comp_201014_relocations_full_denser_loess_wo108156.RData')

# If starting from here can load:

load('newup_se_comp_201014_relocations_full_denser_loess_wo108156.RData')

# Work out the means and deseasonalised series:

menmodel40a=as.data.frame(matrix(nrow=366,ncol=420))
menmodel45a=as.data.frame(matrix(nrow=366,ncol=420))
menmodel40b=as.data.frame(matrix(nrow=366,ncol=420))
menmodel45b=as.data.frame(matrix(nrow=366,ncol=420))

newup$Station=sort(rep(1:420,15340))

for (i in 1:420){
	stat=newup[newup$Station==i,]
	statn29=stat[stat$Dyear!=59.5,]
	stat29=stat[stat$Dyear==59.5,]
	statar45a=t(array(statn29$lsmodel45a,dim=c(365,42)))
	menmodel45a[1:59,i]=apply(statar45a[,1:59],2,mean)
	menmodel45a[61:366,i]=apply(statar45a[,60:365],2,mean)
	menmodel45a[60,i]=mean(stat29$lsmodel45a)
	statar45b=t(array(statn29$lsmodel45b,dim=c(365,42)))
	menmodel45b[1:59,i]=apply(statar45b[,1:59],2,mean)
	menmodel45b[61:366,i]=apply(statar45b[,60:365],2,mean)
	menmodel45b[60,i]=mean(stat29$lsmodel45b)
	statar40a=t(array(statn29$lsmodel40a,dim=c(365,42)))
	menmodel40a[1:59,i]=apply(statar40a[,1:59],2,mean)
	menmodel40a[61:366,i]=apply(statar40a[,60:365],2,mean)
	menmodel40a[60,i]=mean(stat29$lsmodel40a)
	statar40b=t(array(statn29$lsmodel40b,dim=c(365,42)))
	menmodel40b[1:59,i]=apply(statar40b[,1:59],2,mean)
	menmodel40b[61:366,i]=apply(statar40b[,60:365],2,mean)
	menmodel40b[60,i]=mean(stat29$lsmodel40b)
}
 
save(menmodel40a,menmodel45a,menmodel40b,menmodel45b,file='mean_se_comp_201014_relocations_denser_full_wo108156.RData')

menmodel401a=rbind(menmodel40a[-60,],menmodel40a[-60,],menmodel40a,menmodel40a[-60,],menmodel40a[-60,],menmodel40a[-60,],menmodel40a,menmodel40a[-60,],menmodel40a[-60,],menmodel40a[-60,],menmodel40a,menmodel40a[-60,],menmodel40a[-60,],menmodel40a[-60,],menmodel40a,menmodel40a[-60,],menmodel40a[-60,],menmodel40a[-60,],menmodel40a,menmodel40a[-60,],menmodel40a[-60,],menmodel40a[-60,],menmodel40a,menmodel40a[-60,],menmodel40a[-60,],menmodel40a[-60,],menmodel40a,menmodel40a[-60,],menmodel40a[-60,],menmodel40a[-60,],menmodel40a,menmodel40a[-60,],menmodel40a[-60,],menmodel40a[-60,],menmodel40a,menmodel40a[-60,],menmodel40a[-60,],menmodel40a[-60,],menmodel40a,menmodel40a[-60,],menmodel40a[-60,],menmodel40a[-60,])
rm(menmodel40a)
menmodel451a=rbind(menmodel45a[-60,],menmodel45a[-60,],menmodel45a,menmodel45a[-60,],menmodel45a[-60,],menmodel45a[-60,],menmodel45a,menmodel45a[-60,],menmodel45a[-60,],menmodel45a[-60,],menmodel45a,menmodel45a[-60,],menmodel45a[-60,],menmodel45a[-60,],menmodel45a,menmodel45a[-60,],menmodel45a[-60,],menmodel45a[-60,],menmodel45a,menmodel45a[-60,],menmodel45a[-60,],menmodel45a[-60,],menmodel45a,menmodel45a[-60,],menmodel45a[-60,],menmodel45a[-60,],menmodel45a,menmodel45a[-60,],menmodel45a[-60,],menmodel45a[-60,],menmodel45a,menmodel45a[-60,],menmodel45a[-60,],menmodel45a[-60,],menmodel45a,menmodel45a[-60,],menmodel45a[-60,],menmodel45a[-60,],menmodel45a,menmodel45a[-60,],menmodel45a[-60,],menmodel45a[-60,])
rm(menmodel45a)

menmodel401b=rbind(menmodel40b[-60,],menmodel40b[-60,],menmodel40b,menmodel40b[-60,],menmodel40b[-60,],menmodel40b[-60,],menmodel40b,menmodel40b[-60,],menmodel40b[-60,],menmodel40b[-60,],menmodel40b,menmodel40b[-60,],menmodel40b[-60,],menmodel40b[-60,],menmodel40b,menmodel40b[-60,],menmodel40b[-60,],menmodel40b[-60,],menmodel40b,menmodel40b[-60,],menmodel40b[-60,],menmodel40b[-60,],menmodel40b,menmodel40b[-60,],menmodel40b[-60,],menmodel40b[-60,],menmodel40b,menmodel40b[-60,],menmodel40b[-60,],menmodel40b[-60,],menmodel40b,menmodel40b[-60,],menmodel40b[-60,],menmodel40b[-60,],menmodel40b,menmodel40b[-60,],menmodel40b[-60,],menmodel40b[-60,],menmodel40b,menmodel40b[-60,],menmodel40b[-60,],menmodel40b[-60,])
rm(menmodel40b)
menmodel451b=rbind(menmodel45b[-60,],menmodel45b[-60,],menmodel45b,menmodel45b[-60,],menmodel45b[-60,],menmodel45b[-60,],menmodel45b,menmodel45b[-60,],menmodel45b[-60,],menmodel45b[-60,],menmodel45b,menmodel45b[-60,],menmodel45b[-60,],menmodel45b[-60,],menmodel45b,menmodel45b[-60,],menmodel45b[-60,],menmodel45b[-60,],menmodel45b,menmodel45b[-60,],menmodel45b[-60,],menmodel45b[-60,],menmodel45b,menmodel45b[-60,],menmodel45b[-60,],menmodel45b[-60,],menmodel45b,menmodel45b[-60,],menmodel45b[-60,],menmodel45b[-60,],menmodel45b,menmodel45b[-60,],menmodel45b[-60,],menmodel45b[-60,],menmodel45b,menmodel45b[-60,],menmodel45b[-60,],menmodel45b[-60,],menmodel45b,menmodel45b[-60,],menmodel45b[-60,],menmodel45b[-60,])
rm(menmodel45b)

save(menmodel401a,menmodel451a,menmodel401b,menmodel451b,file='meantab_se_comp_201014_relcoations_denser_full_wo108156.RData')

# Now is it easier to put the predicted series in table form or the measns in column form (I think the former - as long as the subtraction still works then (it does as long as you loop over the columns instead of trying to do it all in one go I think...)

# Create data frames to store the predictions in in a column by column format

model40a=as.data.frame(matrix(nrow=15340,ncol=420))
model45a=as.data.frame(matrix(nrow=15340,ncol=420))
model40b=as.data.frame(matrix(nrow=15340,ncol=420))
model45b=as.data.frame(matrix(nrow=15340,ncol=420))

# Fill the data frames with predictions in a column by column format for each station

for (i in 1:420){
	j1=(i-1)*15340+1
	j2=i*15340
	new1=newup[newup$Station==i,]
	model40a[,i]=new1$lsmodel40a
	model45a[,i]=new1$lsmodel45a
	model40b[,i]=new1$lsmodel40b
	model45b[,i]=new1$lsmodel45b
}

# Create data frames for the deseasonalised values - one column for each station:

deseason40a=as.data.frame(matrix(nrow=15340,ncol=420))
deseason45a=as.data.frame(matrix(nrow=15340,ncol=420))
deseason40b=as.data.frame(matrix(nrow=15340,ncol=420))
deseason45b=as.data.frame(matrix(nrow=15340,ncol=420))

# Fill the data frames by subtracting the mean for each station from the prediction for each station on a column by column basis:

for (i in 1:420){
	deseason40a[,i]=model40a[,i]-menmodel401a[,i]
	deseason45a[,i]=model45a[,i]-menmodel451a[,i]
	deseason40b[,i]=model40b[,i]-menmodel401b[,i]
	deseason45b[,i]=model45b[,i]-menmodel451b[,i]
}

save(deseason40a,deseason45a,deseason40b,deseason45b,file='deseasontab_se_comp_201014_relocations_denser_full_wo108156.RData')




