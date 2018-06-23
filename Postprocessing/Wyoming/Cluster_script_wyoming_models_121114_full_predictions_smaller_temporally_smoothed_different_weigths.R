# Looking at just taking stations into account that physically fall within a 70000km2 circle of the focus station;

# Load the necessary packages first:

library(mgcv)
library(akima)
library(fields)

# Load the necessary dataframes and other R things :

load('loesssurf1.RData') 
load('WYcoast1relocor_30614.RData') 
load('preds_wy_with_relocations_full_smaller_11714.RData')
load('Useful_xs.RData')

# Can load the already saved dataframes:

load('newup_wy_comp_12814_relocations_full_smaller_22.RData'); newup22=newup
load('newup_wy_comp_22914_relocations_full_smaller_1518_temporal_less_stations_different_smoothing.RData'); newup1518=newup
load('newup_wy_comp_17714_relocations_full_smaller_2025.RData')

newup$lsmodel22=newup22$lsmodel22 # So that I can combine the two datasets
newup$lsmodel18=newup1518$lsmodel18
newup$lsmodel15=newup1518$lsmodel15
rm(newup22,newup1518) # So I don't have the massive dataset stored twice

# Look at creating the loess smoothed versions of the errors:

#for (j in 1:15340){
#	day=newup[newup$Time==j,]
#
#	namemodel25=loess.surf1(day$pred5th1gam,call1,degree=2,span=ls25)
#	namemodel20=loess.surf1(day$pred5th1gam,call1,degree=2,span=ls20)
#
#	j1=150*(j-1)+1
#	j2=150*j
#	lsmodel25[j1:j2,1]=seq(1,150)
#	lsmodel25[j1:j2,2]=namemodel25
#	lsmodel20[j1:j2,1]=seq(1,150)
#	lsmodel20[j1:j2,2]=namemodel20
#
#}

#lsmodel25a=lsmodel25[with(lsmodel25, order(lsmodel25[,1])), ] # Puts the noise in station order 
#lsmodel25c=lsmodel25a[,2] # Gets just the noise column
#lsmodel20a=lsmodel20[with(lsmodel20, order(lsmodel20[,1])), ]
#lsmodel20c=lsmodel20a[,2]

#save(lsmodel25c,lsmodel20c,file='loessmodel_wy_comp_17714_relocations_full_smaller_2025.RData')

load('loessmodel_wy_comp_17714_relocations_full_smaller_2025.RData')
load('loessmodel_wy_comp_12814_relocations_full_smaller_22.RData')
load('loessmodel_wy_comp_15914_relocations_full_smaller_1518_.RData')

# Now want to create a moving average series from each of these series in turn

# Create a dataframe of this information:

library(TTR)

temporalsmooth=as.data.frame(matrix(nrow=2301000,ncol=11))
names(temporalsmooth)=c('Station','lsmodel15c','lsmodel18c','lsmodel20c','lsmodel22c','lsmodel25c','lsmodel15w9','lsmodel18w9','lsmodel20w9','lsmodel22w9','lsmodel25w9')

temporalsmooth$Station=rep(1:150,15340)
temporalsmooth$lsmodel15c=lsmodel15c
temporalsmooth$lsmodel18c=lsmodel18c
temporalsmooth$lsmodel20c=lsmodel20c
temporalsmooth$lsmodel22c=lsmodel22c
temporalsmooth$lsmodel25c=lsmodel25c

# At the moment the auto-correlations are too high initially and then go back to being too low => see if adjusting the weighting helps 

for (i in 1:150){

	stat=temporalsmooth[temporalsmooth$Station==i,]
	temporalsmooth$lsmodel15w9[((i-1)*15340+9):(i*15340)]=na.omit(WMA(stat$lsmodel15c,n=9,wts=c(x1,x2,x3,x4,x5,x6,x7,x8,x9)))
	temporalsmooth$lsmodel15w9[((i-1)*15340+1):((i-1)*15340+8)]=temporalsmooth$lsmodel15w9[((i-1)*15340+9)]
	temporalsmooth$lsmodel18w9[((i-1)*15340+9):(i*15340)]=na.omit(WMA(stat$lsmodel18c,n=9,wts=c(x1,x2,x3,x4,x5,x6,x7,x8,x9)))
	temporalsmooth$lsmodel18w9[((i-1)*15340+1):((i-1)*15340+8)]=temporalsmooth$lsmodel18w9[((i-1)*15340+9)]
	temporalsmooth$lsmodel20w9[((i-1)*15340+9):(i*15340)]=na.omit(WMA(stat$lsmodel20c,n=9,wts=c(x1,x2,x3,x4,x5,x6,x7,x8,x9)))
	temporalsmooth$lsmodel20w9[((i-1)*15340+1):((i-1)*15340+8)]=temporalsmooth$lsmodel20w9[((i-1)*15340+9)]
	temporalsmooth$lsmodel22w9[((i-1)*15340+9):(i*15340)]=na.omit(WMA(stat$lsmodel22c,n=9,wts=c(x1,x2,x3,x4,x5,x6,x7,x8,x9)))
	temporalsmooth$lsmodel22w9[((i-1)*15340+1):((i-1)*15340+8)]=temporalsmooth$lsmodel22w9[((i-1)*15340+9)]
	temporalsmooth$lsmodel25w9[((i-1)*15340+9):(i*15340)]=na.omit(WMA(stat$lsmodel25c,n=9,wts=c(x1,x2,x3,x4,x5,x6,x7,x8,x9)))
	temporalsmooth$lsmodel25w9[((i-1)*15340+1):((i-1)*15340+8)]=temporalsmooth$lsmodel25w9[((i-1)*15340+9)]

}

save(temporalsmooth,file='temporalsmooth_wy_full_smaller_121114_weighted_averaging_different.RData')

newup$lsmodel25w9=60-(temporalsmooth$lsmodel25w9+(60-newup$pred5th1)) # 60 - (temporal noise + original prediction) 
newup$lsmodel22w9=60-(temporalsmooth$lsmodel22w9+(60-newup$pred5th1)) 
newup$lsmodel20w9=60-(temporalsmooth$lsmodel20w9+(60-newup$pred5th1))
newup$lsmodel18w9=60-(temporalsmooth$lsmodel18w9+(60-newup$pred5th1))
newup$lsmodel15w9=60-(temporalsmooth$lsmodel15w9+(60-newup$pred5th1))

save(newup,file='newup_wy_comp_121114_relocations_full_smaller_temporal_weighted_averaging_different.RData')

# Work out the means and deseasonalised series:

menmodel25=as.data.frame(matrix(nrow=366,ncol=150))
menmodel22=as.data.frame(matrix(nrow=366,ncol=150))
menmodel20=as.data.frame(matrix(nrow=366,ncol=150))
menmodel18=as.data.frame(matrix(nrow=366,ncol=150))
menmodel15=as.data.frame(matrix(nrow=366,ncol=150))

newup$Station=sort(rep(1:150,15340))

for (i in 1:150){
	stat=newup[newup$Station==i,]
	statn29=stat[stat$Dyear!=59.5,]
	stat29=stat[stat$Dyear==59.5,]
	statar25=t(array(statn29$lsmodel25w9,dim=c(365,42)))
	statar22=t(array(statn29$lsmodel22w9,dim=c(365,42)))
	statar20=t(array(statn29$lsmodel20w9,dim=c(365,42)))
	statar18=t(array(statn29$lsmodel18w9,dim=c(365,42)))
	statar15=t(array(statn29$lsmodel15w9,dim=c(365,42)))
	menmodel25[1:59,i]=apply(statar25[,1:59],2,mean)
	menmodel22[1:59,i]=apply(statar22[,1:59],2,mean)
	menmodel20[1:59,i]=apply(statar20[,1:59],2,mean)
	menmodel18[1:59,i]=apply(statar18[,1:59],2,mean)
	menmodel15[1:59,i]=apply(statar15[,1:59],2,mean)
	menmodel25[61:366,i]=apply(statar25[,60:365],2,mean)
	menmodel22[61:366,i]=apply(statar22[,60:365],2,mean)
	menmodel20[61:366,i]=apply(statar20[,60:365],2,mean)
	menmodel18[61:366,i]=apply(statar18[,60:365],2,mean)
	menmodel15[61:366,i]=apply(statar15[,60:365],2,mean)
	menmodel25[60,i]=mean(stat29$lsmodel25w9)
	menmodel22[60,i]=mean(stat29$lsmodel22w9)
	menmodel20[60,i]=mean(stat29$lsmodel20w9)
	menmodel18[60,i]=mean(stat29$lsmodel18w9)
	menmodel15[60,i]=mean(stat29$lsmodel15w9)
}

save(menmodel25,menmodel20,menmodel22,menmodel18,menmodel15,file='mean_wy_comp_121114_relocations_smaller_full_temporal_weighted_averaging.RData')

menmodel251=rbind(menmodel25[-60,],menmodel25[-60,],menmodel25,menmodel25[-60,],menmodel25[-60,],menmodel25[-60,],menmodel25,menmodel25[-60,],menmodel25[-60,],menmodel25[-60,],menmodel25,menmodel25[-60,],menmodel25[-60,],menmodel25[-60,],menmodel25,menmodel25[-60,],menmodel25[-60,],menmodel25[-60,],menmodel25,menmodel25[-60,],menmodel25[-60,],menmodel25[-60,],menmodel25,menmodel25[-60,],menmodel25[-60,],menmodel25[-60,],menmodel25,menmodel25[-60,],menmodel25[-60,],menmodel25[-60,],menmodel25,menmodel25[-60,],menmodel25[-60,],menmodel25[-60,],menmodel25,menmodel25[-60,],menmodel25[-60,],menmodel25[-60,],menmodel25,menmodel25[-60,],menmodel25[-60,],menmodel25[-60,])
rm(menmodel25)
menmodel221=rbind(menmodel22[-60,],menmodel22[-60,],menmodel22,menmodel22[-60,],menmodel22[-60,],menmodel22[-60,],menmodel22,menmodel22[-60,],menmodel22[-60,],menmodel22[-60,],menmodel22,menmodel22[-60,],menmodel22[-60,],menmodel22[-60,],menmodel22,menmodel22[-60,],menmodel22[-60,],menmodel22[-60,],menmodel22,menmodel22[-60,],menmodel22[-60,],menmodel22[-60,],menmodel22,menmodel22[-60,],menmodel22[-60,],menmodel22[-60,],menmodel22,menmodel22[-60,],menmodel22[-60,],menmodel22[-60,],menmodel22,menmodel22[-60,],menmodel22[-60,],menmodel22[-60,],menmodel22,menmodel22[-60,],menmodel22[-60,],menmodel22[-60,],menmodel22,menmodel22[-60,],menmodel22[-60,],menmodel22[-60,])
rm(menmodel22)
menmodel201=rbind(menmodel20[-60,],menmodel20[-60,],menmodel20,menmodel20[-60,],menmodel20[-60,],menmodel20[-60,],menmodel20,menmodel20[-60,],menmodel20[-60,],menmodel20[-60,],menmodel20,menmodel20[-60,],menmodel20[-60,],menmodel20[-60,],menmodel20,menmodel20[-60,],menmodel20[-60,],menmodel20[-60,],menmodel20,menmodel20[-60,],menmodel20[-60,],menmodel20[-60,],menmodel20,menmodel20[-60,],menmodel20[-60,],menmodel20[-60,],menmodel20,menmodel20[-60,],menmodel20[-60,],menmodel20[-60,],menmodel20,menmodel20[-60,],menmodel20[-60,],menmodel20[-60,],menmodel20,menmodel20[-60,],menmodel20[-60,],menmodel20[-60,],menmodel20,menmodel20[-60,],menmodel20[-60,],menmodel20[-60,])
rm(menmodel20)
menmodel181=rbind(menmodel18[-60,],menmodel18[-60,],menmodel18,menmodel18[-60,],menmodel18[-60,],menmodel18[-60,],menmodel18,menmodel18[-60,],menmodel18[-60,],menmodel18[-60,],menmodel18,menmodel18[-60,],menmodel18[-60,],menmodel18[-60,],menmodel18,menmodel18[-60,],menmodel18[-60,],menmodel18[-60,],menmodel18,menmodel18[-60,],menmodel18[-60,],menmodel18[-60,],menmodel18,menmodel18[-60,],menmodel18[-60,],menmodel18[-60,],menmodel18,menmodel18[-60,],menmodel18[-60,],menmodel18[-60,],menmodel18,menmodel18[-60,],menmodel18[-60,],menmodel18[-60,],menmodel18,menmodel18[-60,],menmodel18[-60,],menmodel18[-60,],menmodel18,menmodel18[-60,],menmodel18[-60,],menmodel18[-60,])
rm(menmodel18)
menmodel151=rbind(menmodel15[-60,],menmodel15[-60,],menmodel15,menmodel15[-60,],menmodel15[-60,],menmodel15[-60,],menmodel15,menmodel15[-60,],menmodel15[-60,],menmodel15[-60,],menmodel15,menmodel15[-60,],menmodel15[-60,],menmodel15[-60,],menmodel15,menmodel15[-60,],menmodel15[-60,],menmodel15[-60,],menmodel15,menmodel15[-60,],menmodel15[-60,],menmodel15[-60,],menmodel15,menmodel15[-60,],menmodel15[-60,],menmodel15[-60,],menmodel15,menmodel15[-60,],menmodel15[-60,],menmodel15[-60,],menmodel15,menmodel15[-60,],menmodel15[-60,],menmodel15[-60,],menmodel15,menmodel15[-60,],menmodel15[-60,],menmodel15[-60,],menmodel15,menmodel15[-60,],menmodel15[-60,],menmodel15[-60,])
rm(menmodel15)

save(menmodel251,menmodel201,menmodel221,menmodel181,menmodel151,file='meantab_wy_comp_121114_relcoations_smaller_full_temporal_weighted_averaging.RData')

# Now is it easier to put the predicted series in table form or the measns in column form (I think the former - as long as the subtraction still works then (it does as long as you loop over the columns instead of trying to do it all in one go I think...)

# Create data frames to store the predictions in in a column by column format

model25=as.data.frame(matrix(nrow=15340,ncol=150))
model22=as.data.frame(matrix(nrow=15340,ncol=150))
model20=as.data.frame(matrix(nrow=15340,ncol=150))
model18=as.data.frame(matrix(nrow=15340,ncol=150))
model15=as.data.frame(matrix(nrow=15340,ncol=150))

# Fill the data frames with predictions in a column by column format for each station

for (i in 1:150){
	j1=(i-1)*15340+1
	j2=i*15340
	new1=newup[newup$Station==i,]
	model25[,i]=new1$lsmodel25w9
	model22[,i]=new1$lsmodel22w9
	model20[,i]=new1$lsmodel20w9
	model18[,i]=new1$lsmodel18w9
	model15[,i]=new1$lsmodel15w9
}

# Create data frames for the deseasonalised values - one column for each station:

deseason25w9=as.data.frame(matrix(nrow=15340,ncol=150))
deseason22w9=as.data.frame(matrix(nrow=15340,ncol=150))
deseason20w9=as.data.frame(matrix(nrow=15340,ncol=150))
deseason18w9=as.data.frame(matrix(nrow=15340,ncol=150))
deseason15w9=as.data.frame(matrix(nrow=15340,ncol=150))

# Fill the data frames by subtracting the mean for each station from the prediction for each station on a column by column basis:

for (i in 1:150){
	deseason25w9[,i]=model25[,i]-menmodel251[,i]
	deseason22w9[,i]=model22[,i]-menmodel221[,i]
	deseason20w9[,i]=model20[,i]-menmodel201[,i]
	deseason18w9[,i]=model18[,i]-menmodel181[,i]
	deseason15w9[,i]=model15[,i]-menmodel151[,i]
}

save(deseason25w9,deseason20w9,deseason22w9,deseason18w9,deseason15w9,file='deseasontab_wy_comp_121114_relocations_smaller_full_temporal_weighted_averaging.RData')



