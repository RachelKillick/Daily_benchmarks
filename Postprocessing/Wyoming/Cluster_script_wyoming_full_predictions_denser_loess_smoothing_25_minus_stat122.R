# Load the necessary packages first:

library(mgcv)
library(akima)
library(fields)

# Load the necessary dataframes and other R things :

load('loesssurf1.RData') 
load('WYcoast1reloc_30614.RData') 
load('preds_wy_with_relocations_full_denser_11714.RData')

# Create a data frame to store values in

newup=WYcoast1reloc
rm(WYcoast1reloc) # No point having the same massive dataset in here twice under two different names

newup$pred5th1=60-pred5th1all

newup$pred5th1gama=pred5th1gama[,1]-pred5th1all
newup$pred5th1gamb=pred5th1gamb[,1]-pred5th1all # Need two versions because I will have two versions of this world

rm(pred5th1gam)

newup$Station=sort(rep(1:159,30680))

newup=newup[newup$Station!=122,]

day1170=newup[newup$Time==1,]

call1=as.matrix(cbind(day1170$Lat,day1170$Long))
 
# Want to be able to get the geographically closest stations in the smoothing, not just the ones R thinks are closest => use the rdist command to work out the distances East and North of the most southwesterly point of the region (-111.1,41) (this has had to change slightly in this expanded dataset as before my most westerly point wasn't quite as westerly!)

lon=rdist.earth(cbind(call1[,2],rep(41,316)),cbind(-111.1,41),miles=FALSE)
lat=rdist.earth(cbind(rep(-111.1,316),call1[,1]),cbind(-111.1,41),miles=FALSE)

dist=rdist.earth(cbind(day1170$Long,day1170$Lat))

call1=cbind(lon,lat)

lsmodel25a=data.frame(matrix(ncol=2,nrow=4847440)) 
lsmodel25b=data.frame(matrix(ncol=2,nrow=4847440))

ls25=25/316

# Look at creating the loess smoothed versions of the errors:

for (j in 1:15340){
	day=newup[newup$Time==j,]

	namemodel25a=loess.surf1(day$pred5th1gama,call1,degree=2,span=ls25)
	namemodel25b=loess.surf1(day$pred5th1gamb,call1,degree=2,span=ls25)

	j1=316*(j-1)+1
	j2=316*j
	lsmodel25a[j1:j2,1]=seq(1,316)
	lsmodel25a[j1:j2,2]=namemodel25a
	lsmodel25b[j1:j2,1]=seq(1,316)
	lsmodel25b[j1:j2,2]=namemodel25b

}

lsmodel25aa=lsmodel25a[with(lsmodel25a, order(lsmodel25a[,1])), ]
lsmodel25ca=lsmodel25aa[,2]
lsmodel25ab=lsmodel25b[with(lsmodel25b, order(lsmodel25b[,1])), ]
lsmodel25cb=lsmodel25ab[,2]

save(lsmodel25ca,lsmodel25cb,file='loessmodel_wy_comp_31014_relocations_full_denser_25_minus_stat122.RData')

newup$lsmodel25a=60-(lsmodel25aa[,2]+(60-newup$pred5th1))
newup$lsmodel25b=60-(lsmodel25ab[,2]+(60-newup$pred5th1))

save(newup,file='newup_wy_comp_31014_relocations_full_denser_25_minus_stat122.RData')

# Work out the means and deseasonalised series:

menmodel25a=as.data.frame(matrix(nrow=366,ncol=316))
menmodel25b=as.data.frame(matrix(nrow=366,ncol=316))

newup$Station=sort(rep(1:316,15340))

for (i in 1:316){

	stat=newup[newup$Station==i,]
	statn29=stat[stat$Dyear!=59.5,]
	stat29=stat[stat$Dyear==59.5,]
	statar25a=t(array(statn29$lsmodel25a,dim=c(365,42)))
	menmodel25a[1:59,i]=apply(statar25a[,1:59],2,mean)
	menmodel25a[61:366,i]=apply(statar25a[,60:365],2,mean)
	menmodel25a[60,i]=mean(stat29$lsmodel25a)
	statar25b=t(array(statn29$lsmodel25b,dim=c(365,42)))
	menmodel25b[1:59,i]=apply(statar25b[,1:59],2,mean)
	menmodel25b[61:366,i]=apply(statar25b[,60:365],2,mean)
	menmodel25b[60,i]=mean(stat29$lsmodel25b)

}

save(menmodel25a,menmodel25b,file='mean_wy_comp_31014_relocations_denser_full_25_minus_stat122.RData')

menmodel251a=rbind(menmodel25a[-60,],menmodel25a[-60,],menmodel25a,menmodel25a[-60,],menmodel25a[-60,],menmodel25a[-60,],menmodel25a,menmodel25a[-60,],menmodel25a[-60,],menmodel25a[-60,],menmodel25a,menmodel25a[-60,],menmodel25a[-60,],menmodel25a[-60,],menmodel25a,menmodel25a[-60,],menmodel25a[-60,],menmodel25a[-60,],menmodel25a,menmodel25a[-60,],menmodel25a[-60,],menmodel25a[-60,],menmodel25a,menmodel25a[-60,],menmodel25a[-60,],menmodel25a[-60,],menmodel25a,menmodel25a[-60,],menmodel25a[-60,],menmodel25a[-60,],menmodel25a,menmodel25a[-60,],menmodel25a[-60,],menmodel25a[-60,],menmodel25a,menmodel25a[-60,],menmodel25a[-60,],menmodel25a[-60,],menmodel25a,menmodel25a[-60,],menmodel25a[-60,],menmodel25a[-60,])
rm(menmodel25a)

menmodel251b=rbind(menmodel25b[-60,],menmodel25b[-60,],menmodel25b,menmodel25b[-60,],menmodel25b[-60,],menmodel25b[-60,],menmodel25b,menmodel25b[-60,],menmodel25b[-60,],menmodel25b[-60,],menmodel25b,menmodel25b[-60,],menmodel25b[-60,],menmodel25b[-60,],menmodel25b,menmodel25b[-60,],menmodel25b[-60,],menmodel25b[-60,],menmodel25b,menmodel25b[-60,],menmodel25b[-60,],menmodel25b[-60,],menmodel25b,menmodel25b[-60,],menmodel25b[-60,],menmodel25b[-60,],menmodel25b,menmodel25b[-60,],menmodel25b[-60,],menmodel25b[-60,],menmodel25b,menmodel25b[-60,],menmodel25b[-60,],menmodel25b[-60,],menmodel25b,menmodel25b[-60,],menmodel25b[-60,],menmodel25b[-60,],menmodel25b,menmodel25b[-60,],menmodel25b[-60,],menmodel25b[-60,])
rm(menmodel25b)

save(menmodel251a,menmodel251b,file='meantab_wy_comp_31014_relcoations_denser_full_25_minus_stat122.RData')

# Now is it easier to put the predicted series in table form or the measns in column form (I think the former - as long as the subtraction still works then (it does as long as you loop over the columns instead of trying to do it all in one go I think...)

# Create data frames to store the predictions in in a column by column format

model25a=as.data.frame(matrix(nrow=15340,ncol=316))
model25b=as.data.frame(matrix(nrow=15340,ncol=316))

# Fill the data frames with predictions in a column by column format for each station

for (i in 1:316){
	j1=(i-1)*15340+1
	j2=i*15340
	new1=newup[newup$Station==i,]
	model25a[,i]=new1$lsmodel25a
	model25b[,i]=new1$lsmodel25b
}

# Create data frames for the deseasonalised values - one column for each station:

deseason25a=as.data.frame(matrix(nrow=15340,ncol=316))
deseason25b=as.data.frame(matrix(nrow=15340,ncol=316))

# Fill the data frames by subtracting the mean for each station from the prediction for each station on a column by column basis:

for (i in 1:316){
	deseason25a[,i]=model25a[,i]-menmodel251a[,i]
	deseason25b[,i]=model25b[,i]-menmodel251b[,i]
}

save(deseason25a,deseason25b,file='deseasontab_wy_comp_31014_relocations_denser_full_25_minus_stat122.RData')



