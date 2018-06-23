# Hopefully verging on my final model in the Northeast:

# Load the necessary packages first:

library(mgcv)
library(akima)
library(fields)

# Load the necessary dataframes and other R things:

load('loesssurf1.RData') 
load('NEcoast1relocor_1714.RData') 
load('preds_ne_11714_relocation_full_smaller.RData')

# Want to look at correlations of predictions before and after deseasonalisation:

# Create a data frame to store values in

newup=NEcoast1relocor
rm(NEcoast1relocor)

newup$pred5other=60-pred5other

newup$pred5othergam=pred5othergam[,1]-pred5other

rm(pred5othergam)

newup=newup[newup$Station!=103,]
newup=newup[newup$Station!=126,]

# Re-organise dataframe so predictions and noise match up:

day1170=newup[newup$Time==1,]

call1=as.matrix(cbind(day1170$Lat,day1170$Long))

# Want to be able to get the geographically closest stations in the smoothing, not just the ones R thinks are closest => use the rdist command to work out the distances East and North of the most southwesterly point of the region (-111,41)

lon=rdist.earth(cbind(call1[,2],rep(41,292)),cbind(-80,41),miles=FALSE)
lat=rdist.earth(cbind(rep(-80,292),call1[,1]),cbind(-80,41),miles=FALSE)

call1=cbind(lon,lat) 

lsmodel40=data.frame(matrix(ncol=2,nrow=4479280))

ls40=40/292

# Look at creating the loess smoothed versions of the errors:

for (j in 1:15340){
	day=newup[newup$Time==j,]
	namemodel40=loess.surf1(day$pred5othergam,call1,degree=2,span=ls40)

	j1=292*(j-1)+1
	j2=292*j
	lsmodel40[j1:j2,1]=seq(1,292)
	lsmodel40[j1:j2,2]=namemodel40	
}

lsmodel40a=lsmodel40[with(lsmodel40, order(lsmodel40[,1])), ]
lsmodel40c=lsmodel40a[,2]

save(lsmodel40c,file='loessmodel_ne_comp_221014_relocations_full_40_less.RData')

newup$lsmodel40=60-(lsmodel40a[,2]+(60-newup$pred5other))

save(newup,file='newup_ne_comp_221014_relocations_full_smaller_40_less.RData')

# Work out the means and deseasonalised series:

# The true means will need to be used from an earlier run as otherwise having some stations that do have TMEAN records and some stations that don't will cause problems! 

menmodel40=as.data.frame(matrix(nrow=366,ncol=292))

newup$Station=sort(rep(1:292,15340))

for (i in 1:302){
	stat=newup[newup$Station==i,]
	statn29=stat[stat$Dyear!=59.5,]
	stat29=stat[stat$Dyear==59.5,]
	statar40=t(array(statn29$lsmodel40,dim=c(365,42)))
	menmodel40[1:59,i]=apply(statar40[,1:59],2,mean)
	menmodel40[61:366,i]=apply(statar40[,60:365],2,mean)
	menmodel40[60,i]=mean(stat29$lsmodel40)
}

save(menmodel40,file='mean_ne_comp_221014_relocations_smaller_full_40_less.RData')

menmodel401=rbind(menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,])
rm(menmodel40)

save(menmodel401,file='meantab_ne_comp_221014_relcoations_smaller_full_40_less.RData')

# Create data frames to store the predictions in in a column by column format

model40=as.data.frame(matrix(nrow=15340,ncol=292))

# Fill the data frames with predictions in a column by column format for each station

for (i in 1:292){
	j1=(i-1)*15340+1
	j2=i*15340
	new1=newup[newup$Station==i,]
	model40[,i]=new1$lsmodel40
}

# Create data frames for the deseasonalised values - one column for each station:

deseason40=as.data.frame(matrix(nrow=15340,ncol=292))

# Fill the data frames by subtracting the mean for each station from the prediction for each station on a column by column basis:

for (i in 1:292){
	deseason40[,i]=model40[,i]-menmodel401[,i]
}

save(deseason40,file='deseasontab_ne_comp_221014_relocations_smaller_full_40_less.RData')


