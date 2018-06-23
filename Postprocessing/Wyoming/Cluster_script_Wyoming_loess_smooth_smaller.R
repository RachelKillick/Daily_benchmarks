# Taken from Cluster_script_wyoming_full_predictions_smaller_loess_smoothing_2025.R

# Load the necessary packages first:

library(mgcv)
library(akima)
library(fields)

# Load the necessary dataframes and other R things :

load('loesssurf1.RData') 
load('WYcoast1relocor_30614.RData') 
load('preds_wy_with_relocations_full_smaller_11714.RData')

# Create a data frame to store values in

newup=WYcoast1relocor
rm(WYcoast1relocor) # No point having the same massive dataset in here twice under two different names

newup$pred5th1=60-pred5th1all

newup$pred5th1gam=pred5th1gam[,1]-pred5th1all

rm(pred5th1gam)

day1170=newup[newup$Time==1,]

call1=as.matrix(cbind(day1170$Lat,day1170$Long))
 
# Want to be able to get the geographically closest stations in the smoothing, not just the ones R thinks are closest => use the rdist command to work out the distances East and North of the most southwesterly point of the region (-111.1,41) (this has had to change slightly in this expanded dataset as before my most westerly point wasn't quite as westerly!)

lon=rdist.earth(cbind(call1[,2],rep(41,150)),cbind(-111.1,41),miles=FALSE)
lat=rdist.earth(cbind(rep(-111.1,150),call1[,1]),cbind(-111.1,41),miles=FALSE)

dist=rdist.earth(cbind(day1170$Long,day1170$Lat))

call1=cbind(lon,lat)

lsmodel25=as.data.frame(matrix(ncol=2,nrow=2301000)) 
lsmodel20=as.data.frame(matrix(ncol=2,nrow=2301000)) 

ls25=25/150
ls20=20/150

# Look at creating the loess smoothed versions of the errors:

for (j in 1:15340){
	day=newup[newup$Time==j,]

	namemodel25=loess.surf1(day$pred5th1gam,call1,degree=2,span=ls25)
	namemodel20=loess.surf1(day$pred5th1gam,call1,degree=2,span=ls20)

	j1=150*(j-1)+1
	j2=150*j
	lsmodel25[j1:j2,1]=seq(1,150)
	lsmodel25[j1:j2,2]=namemodel25
	lsmodel20[j1:j2,1]=seq(1,150)
	lsmodel20[j1:j2,2]=namemodel20

}

lsmodel25a=lsmodel25[with(lsmodel25, order(lsmodel25[,1])), ]
lsmodel25c=lsmodel25a[,2]
lsmodel20a=lsmodel20[with(lsmodel20, order(lsmodel20[,1])), ]
lsmodel20c=lsmodel20a[,2]

save(lsmodel25c,lsmodel20c,file='loessmodel_wy_comp_17714_relocations_full_smaller_2025.RData')

newup$lsmodel25=60-(lsmodel25a[,2]+(60-newup$pred5th1))
newup$lsmodel20=60-(lsmodel20a[,2]+(60-newup$pred5th1))

save(newup,file='newup_wy_comp_17714_relocations_full_smaller_2025.RData')

# If starting from here can just do:

load('newup_wy_comp_17714_relocations_full_smaller_2025.RData')

# Work out the means and deseasonalised series:

menmodel25=as.data.frame(matrix(nrow=366,ncol=150))
menmodel20=as.data.frame(matrix(nrow=366,ncol=150))

newup$Station=sort(rep(1:150,15340))

for (i in 1:150){
	for (k in 1:59){
		day=newup[newup$Station==i & newup$Dyear==k,]
		menmodel25[k,i]=mean(day$lsmodel25,na.rm=TRUE)
		menmodel20[k,i]=mean(day$lsmodel20,na.rm=TRUE)
	}
	for (k in 60:365){
		day=newup[newup$Station==i & newup$Dyear==k,]
		menmodel25[(k+1),i]=mean(day$lsmodel25,na.rm=TRUE)
		menmodel20[(k+1),i]=mean(day$lsmodel20,na.rm=TRUE)
	}
	day=newup[newup$Dyear==59.5 & newup$Station==i,]
	menmodel25[60,i]=mean(day$lsmodel25,na.rm=TRUE)
	menmodel20[60,i]=mean(day$lsmodel20,na.rm=TRUE)
}

save(menmodel25,menmodel20,file='mean_wy_comp_17714_relocations_smaller_full_2025.RData')

# If starting from here can just do:

load('mean_wy_comp_17714_relocations_smaller_full_2025.RData')

menmodel251=rbind(menmodel25[-60,],menmodel25[-60,],menmodel25,menmodel25[-60,],menmodel25[-60,],menmodel25[-60,],menmodel25,menmodel25[-60,],menmodel25[-60,],menmodel25[-60,],menmodel25,menmodel25[-60,],menmodel25[-60,],menmodel25[-60,],menmodel25,menmodel25[-60,],menmodel25[-60,],menmodel25[-60,],menmodel25,menmodel25[-60,],menmodel25[-60,],menmodel25[-60,],menmodel25,menmodel25[-60,],menmodel25[-60,],menmodel25[-60,],menmodel25,menmodel25[-60,],menmodel25[-60,],menmodel25[-60,],menmodel25,menmodel25[-60,],menmodel25[-60,],menmodel25[-60,],menmodel25,menmodel25[-60,],menmodel25[-60,],menmodel25[-60,],menmodel25,menmodel25[-60,],menmodel25[-60,],menmodel25[-60,])
rm(menmodel25)
menmodel201=rbind(menmodel20[-60,],menmodel20[-60,],menmodel20,menmodel20[-60,],menmodel20[-60,],menmodel20[-60,],menmodel20,menmodel20[-60,],menmodel20[-60,],menmodel20[-60,],menmodel20,menmodel20[-60,],menmodel20[-60,],menmodel20[-60,],menmodel20,menmodel20[-60,],menmodel20[-60,],menmodel20[-60,],menmodel20,menmodel20[-60,],menmodel20[-60,],menmodel20[-60,],menmodel20,menmodel20[-60,],menmodel20[-60,],menmodel20[-60,],menmodel20,menmodel20[-60,],menmodel20[-60,],menmodel20[-60,],menmodel20,menmodel20[-60,],menmodel20[-60,],menmodel20[-60,],menmodel20,menmodel20[-60,],menmodel20[-60,],menmodel20[-60,],menmodel20,menmodel20[-60,],menmodel20[-60,],menmodel20[-60,])
rm(menmodel20)

save(menmodel251,menmodel201,file='meantab_wy_comp_17714_relcoations_smaller_full_2025.RData')

# Now is it easier to put the predicted series in table form or the measns in column form (I think the former - as long as the subtraction still works then (it does as long as you loop over the columns instead of trying to do it all in one go I think...)

# Create data frames to store the predictions in in a column by column format

model25=as.data.frame(matrix(nrow=15340,ncol=150))
model20=as.data.frame(matrix(nrow=15340,ncol=150))

# Fill the data frames with predictions in a column by column format for each station

for (i in 1:150){
	j1=(i-1)*15340+1
	j2=i*15340
	new1=newup[newup$Station==i,]
	model25[,i]=new1$lsmodel25
	model20[,i]=new1$lsmodel20
}

# Create data frames for the deseasonalised values - one column for each station:

deseason25=as.data.frame(matrix(nrow=15340,ncol=150))
deseason20=as.data.frame(matrix(nrow=15340,ncol=150))

# Fill the data frames by subtracting the mean for each station from the prediction for each station on a column by column basis:

for (i in 1:150){
	deseason25[,i]=model25[,i]-menmodel251[,i]
	deseason20[,i]=model20[,i]-menmodel201[,i]
}

save(deseason25,deseason20,file='deseasontab_wy_comp_17714_relocations_smaller_full_2025.RData')



