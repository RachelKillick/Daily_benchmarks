# This cluster script is the beginning of an attempts to establish which model should be used for modelling mean temperatures in the South East - I am just doing the testing on the last 11 years of data (the same period as in Wyoming) to make the process quicker

# Load the necessary packages first:

library(mgcv)
library(akima)
library(fields)

# Load the necessary dataframes and other R things:

load('loesssurf1.RData') 
load('SWcoast1relocor_1714.RData') 
load('preds_sw_comp_11714_relocations_full_smaller.RData')

# Want to look at correlations of predictions before and after deseasonalisation:

# Create a data frame to store values in

newup=SWcoast1relocor
rm(SWcoast1relocor)

newup$preds5th1=60-preds5th1

newup$preds5th1gam=preds5th1gam[,1]-preds5th1

newup=newup[newup$Station!=64,]
newup=newup[newup$Station!=65,]
newup=newup[newup$Station!=120,]
newup=newup[newup$Station!=143,]
newup=newup[newup$Station!=148,]
newup=newup[newup$Station!=151,]

rm(preds5th1gam)

day1170=newup[newup$Time==1,]

call1=as.matrix(cbind(day1170$Lat,day1170$Long))

# Want to be able to get the geographically closest stations in the smoothing, not just the ones R thinks are closest => use the rdist command to work out the distances East and North of the most southwesterly point of the region (-123,32)

lon=rdist.earth(cbind(call1[,2],rep(32,302)),cbind(-123,32),miles=FALSE)
lat=rdist.earth(cbind(rep(-123,302),call1[,1]),cbind(-123,32),miles=FALSE)

call1=cbind(lon,lat)

lsmodel40=data.frame(matrix(ncol=2,nrow=4632680)) 
lsmodel35=data.frame(matrix(ncol=2,nrow=4632680)) 

ls40=40/302
ls35=35/302


# Look at creating the loess smoothed versions of the errors:

for (j in 1:15340){
	day=newup[newup$Time==j,]
	namemodel40=loess.surf1(day$preds5th1gam,call1,degree=2,span=ls40) 
	namemodel35=loess.surf1(day$preds5th1gam,call1,degree=2,span=ls35) 

	j1=302*(j-1)+1
	j2=302*j
	lsmodel40[j1:j2,1]=seq(1,302)
	lsmodel40[j1:j2,2]=namemodel40
	lsmodel35[j1:j2,1]=seq(1,302)
	lsmodel35[j1:j2,2]=namemodel35

}

lsmodel40a=lsmodel40[with(lsmodel40, order(lsmodel40[,1])), ]
lsmodel40c=lsmodel40a[,2]
lsmodel35a=lsmodel35[with(lsmodel35, order(lsmodel35[,1])), ]
lsmodel35c=lsmodel35a[,2]

save(lsmodel40c,lsmodel35c,file='loessmodel_sw_comp_131014_relocations_full_smaller_station_smoothing_254035_less.RData')

newup$lsmodel40=60-(lsmodel40a[,2]+(60-newup$preds5th1))
newup$lsmodel35=60-(lsmodel35a[,2]+(60-newup$preds5th1))

save(newup,file='newup_sw_comp_131014_relocations_full_smaller_station_smoothing_without_suspect_less.RData')

# Creating the means and deasonalised versions of the predictions:

menmodel35=as.data.frame(matrix(nrow=366,ncol=302))
menmodel40=as.data.frame(matrix(nrow=366,ncol=302))

newup$Station=sort(rep(1:302,15340))

for (i in 1:302){

	stat=newup[newup$Station==i,]
	statn29=stat[stat$Dyear!=59.5,]
	stat29=stat[stat$Dyear==59.5,]
	statar35=t(array(statn29$lsmodel35,dim=c(365,42)))
	statar40=t(array(statn29$lsmodel40,dim=c(365,42)))
	menmodel35[1:59,i]=apply(statar35[,1:59],2,mean)
	menmodel40[1:59,i]=apply(statar40[,1:59],2,mean)
	menmodel35[61:366,i]=apply(statar35[,60:365],2,mean)
	menmodel40[61:366,i]=apply(statar40[,60:365],2,mean)
	menmodel35[60,i]=mean(stat29$lsmodel35)
	menmodel40[60,i]=mean(stat29$lsmodel40)
	
}

save(menmodel35,menmodel40,file='mean_sw_comp131014_relocations_smaller_full_354025_less.RData')

menmodel351=rbind(menmodel35[-60,],menmodel35[-60,],menmodel35,menmodel35[-60,],menmodel35[-60,],menmodel35[-60,],menmodel35,menmodel35[-60,],menmodel35[-60,],menmodel35[-60,],menmodel35,menmodel35[-60,],menmodel35[-60,],menmodel35[-60,],menmodel35,menmodel35[-60,],menmodel35[-60,],menmodel35[-60,],menmodel35,menmodel35[-60,],menmodel35[-60,],menmodel35[-60,],menmodel35,menmodel35[-60,],menmodel35[-60,],menmodel35[-60,],menmodel35,menmodel35[-60,],menmodel35[-60,],menmodel35[-60,],menmodel35,menmodel35[-60,],menmodel35[-60,],menmodel35[-60,],menmodel35,menmodel35[-60,],menmodel35[-60,],menmodel35[-60,],menmodel35,menmodel35[-60,],menmodel35[-60,],menmodel35[-60,])
rm(menmodel35)
menmodel401=rbind(menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,])
rm(menmodel40)

save(menmodel401,menmodel351,file='meantab_sw_comp_131014_relcoations_smaller_full_354025_less.RData')

# Now is it easier to put the predicted series in table form or the measns in column form (I think the former - as long as the subtraction still works then (it does as long as you loop over the columns instead of trying to do it all in one go I think...)

# Create data frames to store the predictions in in a column by column format

model35=as.data.frame(matrix(nrow=15340,ncol=302))
model40=as.data.frame(matrix(nrow=15340,ncol=302))

# Fill the data frames with predictions in a column by column format for each station

for (i in 1:302){
	j1=(i-1)*15340+1
	j2=i*15340
	new1=newup[newup$Station==i,]
	model35[,i]=new1$lsmodel35
	model40[,i]=new1$lsmodel40
}

# Create data frames for the deseasonalised values - one column for each station:

deseason35=as.data.frame(matrix(nrow=15340,ncol=302))
deseason40=as.data.frame(matrix(nrow=15340,ncol=302))

# Fill the data frames by subtracting the mean for each station from the prediction for each station on a column by column basis:

for (i in 1:302){
	deseason35[,i]=model35[,i]-menmodel351[,i]
	deseason40[,i]=model40[,i]-menmodel401[,i]
}

save(deseason35,deseason40,file='deseasontab_sw_comp_131014_relocations_smaller_full_354025_less.RData')




