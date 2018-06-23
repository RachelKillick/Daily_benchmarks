# Hopefully verging on my final model in the Northeast:

# Load the necessary packages first:

library(mgcv)
library(akima)
library(fields)

# Load the necessary dataframes and other R things:

load('loesssurf1.RData') 
load('NEcoast1reloc_1714.RData') 
load('preds_ne_11714_relocation_full_denser.RData')

# Want to look at correlations of predictions before and after deseasonalisation:

# Create a data frame to store values in

newup=NEcoast1reloc
rm(NEcoast1reloc)

newup$pred5other=60-pred5other
newup$pred5othergama=pred5othergama[,1]-pred5other
newup$pred5othergamb=pred5othergamb[,1]-pred5other

rm(pred5othergama,pred5othergamb)

newup$Station1=sort(rep(1:210,30680))

newup=newup[newup$Station1!=176,]
newup=newup[newup$Station1!=193,]
newup=newup[newup$Station1!=199,]

# Re-organise dataframe so predictions and noise match up:

day1170=newup[newup$Time==1,]

call1=as.matrix(cbind(day1170$Lat,day1170$Long))

# Want to be able to get the geographically closest stations in the smoothing, not just the ones R thinks are closest => use the rdist command to work out the distances East and North of the most southwesterly point of the region (-111,41)

lon=rdist.earth(cbind(call1[,2],rep(41,414)),cbind(-80,41),miles=FALSE)
lat=rdist.earth(cbind(rep(-80,414),call1[,1]),cbind(-80,41),miles=FALSE)

call1=cbind(lon,lat) 

lsmodel40a=data.frame(matrix(ncol=2,nrow=6350760))
lsmodel40b=data.frame(matrix(ncol=2,nrow=6350760))

ls40=40/414

# Look at creating the loess smoothed versions of the errors:

for (j in 1:15340){
	day=newup[newup$Time==j,]
	namemodel40a=loess.surf1(day$pred5othergama,call1,degree=2,span=ls40)
	namemodel40b=loess.surf1(day$pred5othergamb,call1,degree=2,span=ls40)

	j1=414*(j-1)+1
	j2=414*j
	lsmodel40a[j1:j2,1]=seq(1,414)
	lsmodel40a[j1:j2,2]=namemodel40a	
	lsmodel40b[j1:j2,1]=seq(1,414)
	lsmodel40b[j1:j2,2]=namemodel40b
}

lsmodel40aa=lsmodel40a[with(lsmodel40a, order(lsmodel40a[,1])), ]
lsmodel40ca=lsmodel40aa[,2]
lsmodel40ab=lsmodel40b[with(lsmodel40b, order(lsmodel40b[,1])), ]
lsmodel40cb=lsmodel40ab[,2]

save(lsmodel40ca,lsmodel40cb,file='loessmodel_ne_comp_221014_relocations_full_denser_40_less.RData')

newup$lsmodel40a=60-(lsmodel40aa[,2]+(60-newup$pred5other))
newup$lsmodel40b=60-(lsmodel40ab[,2]+(60-newup$pred5other))

save(newup,file='newup_ne_comp_221014_relocations_full_denser_40_less.RData')

# Work out the means and deseasonalised series:

# The true means will need to be used from an earlier run as otherwise having some stations that do have TMEAN records and some stations that don't will cause problems! 

menmodel40a=as.data.frame(matrix(nrow=366,ncol=414))
menmodel40b=as.data.frame(matrix(nrow=366,ncol=414))

newup$Station=sort(rep(1:414,15340))

for (i in 1:414){
	stat=newup[newup$Station==i,]
	statn29=stat[stat$Dyear!=59.5,]
	stat29=stat[stat$Dyear==59.5,]
	statar40a=t(array(statn29$lsmodel40a,dim=c(365,42)))
	menmodel40a[1:59,i]=apply(statar40a[,1:59],2,mean)
	menmodel40a[61:366,i]=apply(statar40a[,60:365],2,mean)
	menmodel40a[60,i]=mean(stat29$lsmodel40a)
	statar40b=t(array(statn29$lsmodel40b,dim=c(365,42)))
	menmodel40b[1:59,i]=apply(statar40b[,1:59],2,mean)
	menmodel40b[61:366,i]=apply(statar40b[,60:365],2,mean)
	menmodel40b[60,i]=mean(stat29$lsmodel40b)
}
 

save(menmodel40a,menmodel40b,file='mean_ne_comp_221014_relocations_denser_full_40_less.RData')

menmodel401a=rbind(menmodel40a[-60,],menmodel40a[-60,],menmodel40a,menmodel40a[-60,],menmodel40a[-60,],menmodel40a[-60,],menmodel40a,menmodel40a[-60,],menmodel40a[-60,],menmodel40a[-60,],menmodel40a,menmodel40a[-60,],menmodel40a[-60,],menmodel40a[-60,],menmodel40a,menmodel40a[-60,],menmodel40a[-60,],menmodel40a[-60,],menmodel40a,menmodel40a[-60,],menmodel40a[-60,],menmodel40a[-60,],menmodel40a,menmodel40a[-60,],menmodel40a[-60,],menmodel40a[-60,],menmodel40a,menmodel40a[-60,],menmodel40a[-60,],menmodel40a[-60,],menmodel40a,menmodel40a[-60,],menmodel40a[-60,],menmodel40a[-60,],menmodel40a,menmodel40a[-60,],menmodel40a[-60,],menmodel40a[-60,],menmodel40a,menmodel40a[-60,],menmodel40a[-60,],menmodel40a[-60,])
rm(menmodel40a)
menmodel401b=rbind(menmodel40b[-60,],menmodel40b[-60,],menmodel40b,menmodel40b[-60,],menmodel40b[-60,],menmodel40b[-60,],menmodel40b,menmodel40b[-60,],menmodel40b[-60,],menmodel40b[-60,],menmodel40b,menmodel40b[-60,],menmodel40b[-60,],menmodel40b[-60,],menmodel40b,menmodel40b[-60,],menmodel40b[-60,],menmodel40b[-60,],menmodel40b,menmodel40b[-60,],menmodel40b[-60,],menmodel40b[-60,],menmodel40b,menmodel40b[-60,],menmodel40b[-60,],menmodel40b[-60,],menmodel40b,menmodel40b[-60,],menmodel40b[-60,],menmodel40b[-60,],menmodel40b,menmodel40b[-60,],menmodel40b[-60,],menmodel40b[-60,],menmodel40b,menmodel40b[-60,],menmodel40b[-60,],menmodel40b[-60,],menmodel40b,menmodel40b[-60,],menmodel40b[-60,],menmodel40b[-60,])
rm(menmodel40b)

save(menmodel401a,menmodel401b,file='meantab_ne_comp_221014_relcoations_denser_full_40_less.RData')

# Create data frames to store the predictions in in a column by column format

model40a=as.data.frame(matrix(nrow=15340,ncol=414))
model40b=as.data.frame(matrix(nrow=15340,ncol=414))

# Fill the data frames with predictions in a column by column format for each station

for (i in 1:414){
	j1=(i-1)*15340+1
	j2=i*15340
	new1=newup[newup$Station==i,]
	model40a[,i]=new1$lsmodel40a
	model40b[,i]=new1$lsmodel40b
}

# Create data frames for the deseasonalised values - one column for each station:

deseason40a=as.data.frame(matrix(nrow=15340,ncol=414))
deseason40b=as.data.frame(matrix(nrow=15340,ncol=414))

# Fill the data frames by subtracting the mean for each station from the prediction for each station on a column by column basis:

for (i in 1:414){
	deseason40a[,i]=model40a[,i]-menmodel401a[,i]
	deseason40b[,i]=model40b[,i]-menmodel401b[,i]
}

save(deseason40a,deseason40b,file='deseasontab_ne_comp_221014_relocations_denser_full_40_less.RData')


