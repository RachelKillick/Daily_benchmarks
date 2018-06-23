# Load the necessary packages first:

library(mgcv)
library(akima)
library(fields)

# Load the necessary dataframes and other R things :

load('loesssurf1.RData') 
load('WYcoast1reloc_30614.RData') 
load('preds_wy_with_relocations_full_denser_11714.RData')

# Put what I want in a re-named dataframe:

newup=WYcoast1reloc
rm(WYcoast1reloc) # No point having the same massive dataset in here twice under two different names

newup$pred5th1=60-pred5th1all

newup$pred5th1gama=pred5th1gama[,1]-pred5th1all
newup$pred5th1gamb=pred5th1gamb[,1]-pred5th1all # Need two versions because I will have two versions of this world

#rm(pred5th1gam)

#day1170=newup[newup$Time==1,]

#call1=as.matrix(cbind(day1170$Lat,day1170$Long))
 
# Want to be able to get the geographically closest stations in the smoothing, not just the ones R thinks are closest => use the rdist command to work out the distances East and North of the most southwesterly point of the region (-111.1,41) (this has had to change slightly in this expanded dataset as before my most westerly point wasn't quite as westerly!)

#lon=rdist.earth(cbind(call1[,2],rep(41,318)),cbind(-111.1,41),miles=FALSE)
#lat=rdist.earth(cbind(rep(-111.1,318),call1[,1]),cbind(-111.1,41),miles=FALSE)

#dist=rdist.earth(cbind(day1170$Long,day1170$Lat))

#call1=cbind(lon,lat)

#lsmodel15a=as.data.frame(matrix(ncol=2,nrow=4878120)) 
#lsmodel18a=as.data.frame(matrix(ncol=2,nrow=4878120)) 
#lsmodel15b=as.data.frame(matrix(ncol=2,nrow=4878120)) 
#lsmodel18b=as.data.frame(matrix(ncol=2,nrow=4878120)) 

#ls15=15/318
#ls18=18/318

# Look at creating the loess smoothed versions of the errors:

#for (j in 1:15340){
#	day=newup[newup$Time==j,]

#	namemodel15a=loess.surf1(day$pred5th1gama,call1,degree=2,span=ls15)
#	namemodel18a=loess.surf1(day$pred5th1gama,call1,degree=2,span=ls18)
#	namemodel15b=loess.surf1(day$pred5th1gamb,call1,degree=2,span=ls15)
#	namemodel18b=loess.surf1(day$pred5th1gamb,call1,degree=2,span=ls18)
#
#	j1=318*(j-1)+1
#	j2=318*j
#	lsmodel15a[j1:j2,1]=seq(1,318)
#	lsmodel15a[j1:j2,2]=namemodel15a
#	lsmodel18a[j1:j2,1]=seq(1,318)
#	lsmodel18a[j1:j2,2]=namemodel18a
#	lsmodel15b[j1:j2,1]=seq(1,318)
#	lsmodel15b[j1:j2,2]=namemodel15b
#	lsmodel18b[j1:j2,1]=seq(1,318)
#	lsmodel18b[j1:j2,2]=namemodel18b
#
#}

#lsmodel15aa=lsmodel15a[with(lsmodel15a, order(lsmodel15a[,1])), ]
#lsmodel15ca=lsmodel15aa[,2]
#lsmodel18aa=lsmodel18a[with(lsmodel18a, order(lsmodel18a[,1])), ]
#lsmodel18ca=lsmodel18aa[,2]
#lsmodel15ab=lsmodel15b[with(lsmodel15b, order(lsmodel15b[,1])), ]
#lsmodel15cb=lsmodel15ab[,2]
#lsmodel18ab=lsmodel18b[with(lsmodel18b, order(lsmodel18b[,1])), ]
#lsmodel18cb=lsmodel18ab[,2]

#save(lsmodel15ca,lsmodel18ca,lsmodel15cb,lsmodel18cb,file='loessmodel_wy_comp_22914_relocations_full_denser_1518_.RData')

#load('loessmodel_wy_comp_22914_relocations_full_denser_1518_.RData')

#newup$lsmodel15a=60-(lsmodel15ca+(60-newup$pred5th1))
#newup$lsmodel18a=60-(lsmodel18ca+(60-newup$pred5th1))
#newup$lsmodel15b=60-(lsmodel15cb+(60-newup$pred5th1))
#newup$lsmodel18b=60-(lsmodel18cb+(60-newup$pred5th1))

# Create a dataframe of this information:

#library(forecast)

#temporalsmooth=as.data.frame(matrix(nrow=4878120,ncol=9))
#names(temporalsmooth)=c('Station','lsmodel15ca','lsmodel18ca','lsmodel15ta','lsmodel18ta','lsmodel15cb','lsmodel18cb','lsmodel15tb','lsmodel18tb')

#temporalsmooth$Station=rep(1:318,15340)
#temporalsmooth$lsmodel15ca=lsmodel15ca
#temporalsmooth$lsmodel18ca=lsmodel18ca
#temporalsmooth$lsmodel15cb=lsmodel15cb
#temporalsmooth$lsmodel18cb=lsmodel18cb

#for (i in 1:318){

#	stat=temporalsmooth[temporalsmooth$Station==i,]
#	temporalsmooth$lsmodel15ta[((i-1)*15340+2):(i*15340-1)]=na.omit(ma(stat$lsmodel15ca,order=3,centre=TRUE))
#	temporalsmooth$lsmodel15ta[((i-1)*15340+1)]=temporalsmooth$lsmodel15ta[((i-1)*15340+2)]
#	temporalsmooth$lsmodel15ta[(i*15340)]=temporalsmooth$lsmodel15ta[((i*15340-1))]
#	temporalsmooth$lsmodel18ta[((i-1)*15340+2):(i*15340-1)]=na.omit(ma(stat$lsmodel18ca,order=3,centre=TRUE))
#	temporalsmooth$lsmodel18ta[((i-1)*15340+1)]=temporalsmooth$lsmodel18ta[((i-1)*15340+2)]
#	temporalsmooth$lsmodel18ta[(i*15340)]=temporalsmooth$lsmodel18ta[((i*15340-1))]
#	temporalsmooth$lsmodel15tb[((i-1)*15340+2):(i*15340-1)]=na.omit(ma(stat$lsmodel15cb,order=3,centre=TRUE))
#	temporalsmooth$lsmodel15tb[((i-1)*15340+1)]=temporalsmooth$lsmodel15tb[((i-1)*15340+2)]
#	temporalsmooth$lsmodel15tb[(i*15340)]=temporalsmooth$lsmodel15tb[((i*15340-1))]
#	temporalsmooth$lsmodel18tb[((i-1)*15340+2):(i*15340-1)]=na.omit(ma(stat$lsmodel18cb,order=3,centre=TRUE))
#	temporalsmooth$lsmodel18tb[((i-1)*15340+1)]=temporalsmooth$lsmodel18tb[((i-1)*15340+2)]
#	temporalsmooth$lsmodel18tb[(i*15340)]=temporalsmooth$lsmodel18tb[((i*15340-1))]
#

#}

#save(temporalsmooth,file='temporalsmooth_1518_wy_full_denser_22914_different_smooth.RData')

#newup$lsmodel15ta=60-(temporalsmooth$lsmodel15ta+(60-newup$pred5th1)) # 60 - (temporal noise + original prediction) 
#newup$lsmodel18ta=60-(temporalsmooth$lsmodel18ta+(60-newup$pred5th1)) 
#newup$lsmodel15tb=60-(temporalsmooth$lsmodel15tb+(60-newup$pred5th1)) 
#newup$lsmodel18tb=60-(temporalsmooth$lsmodel18tb+(60-newup$pred5th1)) 

#rm(temporalsmooth) # It's a pretty big dataset to have hanging around!

#save(newup,file='newup_wy_comp_22914_relocations_full_denser_1518_temporal_different_smooth.RData')

load('newup_wy_comp_22914_relocations_full_denser_1518_temporal_different_smooth.RData')

# Work out the means and deseasonalised series:

#menmodel15ta=as.data.frame(matrix(nrow=366,ncol=318))
#menmodel18ta=as.data.frame(matrix(nrow=366,ncol=318))
#menmodel15tb=as.data.frame(matrix(nrow=366,ncol=318))
#menmodel18tb=as.data.frame(matrix(nrow=366,ncol=318))

newup$Station=sort(rep(1:318,15340))

#for (i in 1:318){
#	stat=newup[newup$Station==i,]
#	statn29=stat[stat$Dyear!=59.5,]
#	stat29=stat[stat$Dyear==59.5,]
#	statar15ta=t(array(statn29$lsmodel15ta,dim=c(365,42)))
#	statar18ta=t(array(statn29$lsmodel18ta,dim=c(365,42)))
#	menmodel15ta[1:59,i]=apply(statar15ta[,1:59],2,mean)
#	menmodel18ta[1:59,i]=apply(statar18ta[,1:59],2,mean)
#	menmodel15ta[61:366,i]=apply(statar15ta[,60:365],2,mean)
#	menmodel18ta[61:366,i]=apply(statar18ta[,60:365],2,mean)
#	menmodel15ta[60,i]=mean(stat29$lsmodel15ta)
#	menmodel18ta[60,i]=mean(stat29$lsmodel18ta)
#	statar15tb=t(array(statn29$lsmodel15tb,dim=c(365,42)))
#	statar18tb=t(array(statn29$lsmodel18tb,dim=c(365,42)))
#	menmodel15tb[1:59,i]=apply(statar15tb[,1:59],2,mean)
#	menmodel18tb[1:59,i]=apply(statar18tb[,1:59],2,mean)
#	menmodel15tb[61:366,i]=apply(statar15tb[,60:365],2,mean)
#	menmodel18tb[61:366,i]=apply(statar18tb[,60:365],2,mean)
#	menmodel15tb[60,i]=mean(stat29$lsmodel15tb)
#	menmodel18tb[60,i]=mean(stat29$lsmodel18tb)
#}

#save(menmodel15ta,menmodel18ta,menmodel15tb,menmodel18tb,file='mean_wy_comp_22914_relocations_denser_full_1518_different_smooth.RData')

load('mean_wy_comp_22914_relocations_denser_full_1518_different_smooth.RData')

menmodel15ta1=rbind(menmodel15ta[-60,],menmodel15ta[-60,],menmodel15ta,menmodel15ta[-60,],menmodel15ta[-60,],menmodel15ta[-60,],menmodel15ta,menmodel15ta[-60,],menmodel15ta[-60,],menmodel15ta[-60,],menmodel15ta,menmodel15ta[-60,],menmodel15ta[-60,],menmodel15ta[-60,],menmodel15ta,menmodel15ta[-60,],menmodel15ta[-60,],menmodel15ta[-60,],menmodel15ta,menmodel15ta[-60,],menmodel15ta[-60,],menmodel15ta[-60,],menmodel15ta,menmodel15ta[-60,],menmodel15ta[-60,],menmodel15ta[-60,],menmodel15ta,menmodel15ta[-60,],menmodel15ta[-60,],menmodel15ta[-60,],menmodel15ta,menmodel15ta[-60,],menmodel15ta[-60,],menmodel15ta[-60,],menmodel15ta,menmodel15ta[-60,],menmodel15ta[-60,],menmodel15ta[-60,],menmodel15ta,menmodel15ta[-60,],menmodel15ta[-60,],menmodel15ta[-60,])
rm(menmodel15ta)
menmodel18ta1=rbind(menmodel18ta[-60,],menmodel18ta[-60,],menmodel18ta,menmodel18ta[-60,],menmodel18ta[-60,],menmodel18ta[-60,],menmodel18ta,menmodel18ta[-60,],menmodel18ta[-60,],menmodel18ta[-60,],menmodel18ta,menmodel18ta[-60,],menmodel18ta[-60,],menmodel18ta[-60,],menmodel18ta,menmodel18ta[-60,],menmodel18ta[-60,],menmodel18ta[-60,],menmodel18ta,menmodel18ta[-60,],menmodel18ta[-60,],menmodel18ta[-60,],menmodel18ta,menmodel18ta[-60,],menmodel18ta[-60,],menmodel18ta[-60,],menmodel18ta,menmodel18ta[-60,],menmodel18ta[-60,],menmodel18ta[-60,],menmodel18ta,menmodel18ta[-60,],menmodel18ta[-60,],menmodel18ta[-60,],menmodel18ta,menmodel18ta[-60,],menmodel18ta[-60,],menmodel18ta[-60,],menmodel18ta,menmodel18ta[-60,],menmodel18ta[-60,],menmodel18ta[-60,])
rm(menmodel18ta)
menmodel15tb1=rbind(menmodel15tb[-60,],menmodel15tb[-60,],menmodel15tb,menmodel15tb[-60,],menmodel15tb[-60,],menmodel15tb[-60,],menmodel15tb,menmodel15tb[-60,],menmodel15tb[-60,],menmodel15tb[-60,],menmodel15tb,menmodel15tb[-60,],menmodel15tb[-60,],menmodel15tb[-60,],menmodel15tb,menmodel15tb[-60,],menmodel15tb[-60,],menmodel15tb[-60,],menmodel15tb,menmodel15tb[-60,],menmodel15tb[-60,],menmodel15tb[-60,],menmodel15tb,menmodel15tb[-60,],menmodel15tb[-60,],menmodel15tb[-60,],menmodel15tb,menmodel15tb[-60,],menmodel15tb[-60,],menmodel15tb[-60,],menmodel15tb,menmodel15tb[-60,],menmodel15tb[-60,],menmodel15tb[-60,],menmodel15tb,menmodel15tb[-60,],menmodel15tb[-60,],menmodel15tb[-60,],menmodel15tb,menmodel15tb[-60,],menmodel15tb[-60,],menmodel15tb[-60,])
rm(menmodel15tb)
menmodel18tb1=rbind(menmodel18tb[-60,],menmodel18tb[-60,],menmodel18tb,menmodel18tb[-60,],menmodel18tb[-60,],menmodel18tb[-60,],menmodel18tb,menmodel18tb[-60,],menmodel18tb[-60,],menmodel18tb[-60,],menmodel18tb,menmodel18tb[-60,],menmodel18tb[-60,],menmodel18tb[-60,],menmodel18tb,menmodel18tb[-60,],menmodel18tb[-60,],menmodel18tb[-60,],menmodel18tb,menmodel18tb[-60,],menmodel18tb[-60,],menmodel18tb[-60,],menmodel18tb,menmodel18tb[-60,],menmodel18tb[-60,],menmodel18tb[-60,],menmodel18tb,menmodel18tb[-60,],menmodel18tb[-60,],menmodel18tb[-60,],menmodel18tb,menmodel18tb[-60,],menmodel18tb[-60,],menmodel18tb[-60,],menmodel18tb,menmodel18tb[-60,],menmodel18tb[-60,],menmodel18tb[-60,],menmodel18tb,menmodel18tb[-60,],menmodel18tb[-60,],menmodel18tb[-60,])
rm(menmodel18tb)

save(menmodel15ta1,menmodel18ta1,menmodel15tb1,menmodel18tb1,file='meantab_wy_comp_22914_relcoations_denser_full_1518_different_smooth.RData')

# Now is it easier to put the predicted series in table form or the measns in column form (I think the former - as long as the subtraction still works then (it does as long as you loop over the columns instead of trying to do it all in one go I think...)

# Create data frames to store the predictions in in a column by column format

model15ta=as.data.frame(matrix(nrow=15340,ncol=318))
model18ta=as.data.frame(matrix(nrow=15340,ncol=318))
model15tb=as.data.frame(matrix(nrow=15340,ncol=318))
model18tb=as.data.frame(matrix(nrow=15340,ncol=318))

# Fill the data frames with predictions in a column by column format for each station

for (i in 1:318){
	j1=(i-1)*15340+1
	j2=i*15340
	new1=newup[newup$Station==i,]
	model15ta[,i]=new1$lsmodel15ta
	model18ta[,i]=new1$lsmodel18ta
	model15tb[,i]=new1$lsmodel15tb
	model18tb[,i]=new1$lsmodel18tb
}

# Create data frames for the deseasonalised values - one column for each station:

deseason15ta=as.data.frame(matrix(nrow=15340,ncol=318))
deseason18ta=as.data.frame(matrix(nrow=15340,ncol=318))
deseason15tb=as.data.frame(matrix(nrow=15340,ncol=318))
deseason18tb=as.data.frame(matrix(nrow=15340,ncol=318))

# Fill the data frames by subtracting the mean for each station from the prediction for each station on a column by column basis:

for (i in 1:318){
	deseason15ta[,i]=model15ta[,i]-menmodel15ta1[,i]
	deseason18ta[,i]=model18ta[,i]-menmodel18ta1[,i]
	deseason15tb[,i]=model15tb[,i]-menmodel15tb1[,i]
	deseason18tb[,i]=model18tb[,i]-menmodel18tb1[,i]
}

save(deseason15ta,deseason18ta,deseason15tb,deseason18tb,file='deseasontab_wy_comp_22914_relocations_denser_full_1518_different_smooth.RData')



