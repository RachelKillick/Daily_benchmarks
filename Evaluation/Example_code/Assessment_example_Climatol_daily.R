## The document 'Formatting_example_Climatol_daily.R' has got the data into a format ready to analyse => Read in that dataset and then start, this can be run on a cluster system/ remotely if running line by line interactively is not practical. Running remotely allows multiple contributions to be processed at the same time, although the output will still need to be read for the interpretation of the results. If running remotely there will need to be additional commands added in to ensure plots are saved and not just displayed. ##

# This example looks at analysing the Climatol daily contribution for the best guess for the real world scenario of the South East, but the code can be easily adapted for other regions, scenarios and algorithms. RData files read in here are often larger than can be uploaded to GitHub, but the user can contact rachel.killick@metoffice.gov.uk to arrange for access.

# Values obtained when I ran this code have been left in so future users can ensure they are still getting the same results.

load('Climatol_daily_se1_for_analysis_3915.RData')

# Load the necessary packages for analysis:

library(hydroGOF) # Necessary for the MSE and the MAE and RMSE - not available for the most up to date version of R, but alternative packages should be available.
library(calibrate) # Allows the addition of text to plots
library(sqldf) # Necessary when working out any overlap of extremes

### Set the margins and text size to what we want ###############

par(mai=c(1.02,0.82,0.82,0.42)) # The default margin settings
par(mai=c(1.02,1,0.82,0.42)) # If working from the terminal
par(mai=c(1.1,1.17,0.82,0.42)) # If working from RStudio
par(cex.axis=2, cex.lab=2, cex.main=1, cex.sub=1,lwd=2) # Ensure plots have big enough text! 

######### Create a table to store statistics such as RMSEs, correlations, ... and station locations -  we're not just interested in these values, we're interested in whether the values for the returned series compared to the clean series are better than the corrupted series compared to the clean series ########

statloc=read.table('sew115815_stnlist.tavg') # This is the latitudes and longitudes

datastatm=as.data.frame(matrix(nrow=153,ncol=16)) # A dataframe where clean, released and corrupt are all missing to the same level - the columns are: Station, latitude, longitude, mean of the clean series, mean of the returned series, mean of the deseasonalised clean series, mean of the deseasonalised returned series, standard deviation of the clean series, standard deviation of the returned series, RMSE between clean and returned series, correlations between the deseasonalised clean and returned series, mean of the released series, mean of the deseasonalised released series, standard deviation of the released series, RMSE of the released series and finally correlation between the deseasonalised clean and released series.
names(datastatm)=c('Station','Lat','Long','Meancl','Mean','Meancld','Meand','Sdcl','Sd','RMSE','Correlations', 'Meanrl','Meanrld','Sdrl','RMSErl','Correlationsrl')

datastatm$Station=1:153
datastatm$Lat=statloc[,2]
datastatm$Long=statloc[,3]

for (i in 1:153){
	stat=dataran[dataran$Station==i,]
	datastatm$Meancl[i]=mean(stat$Cleanm,na.rm=TRUE)
	datastatm$Mean[i]=mean(stat$Returned,na.rm=TRUE)
	datastatm$Meancld[i]=mean(stat$deseasoncl,na.rm=TRUE)
	datastatm$Meand[i]=mean(stat$deseasrt,na.rm=TRUE)
	datastatm$Sdcl[i]=sd(stat$Cleanm,na.rm=TRUE)
	datastatm$Sd[i]=sd(stat$Returned,na.rm=TRUE)
	datastatm$RMSE[i]=rmse(stat$Returned,stat$Cleanm,na.rm=TRUE)
	datastatm$Correlations[i]=cor(stat$deseasoncl,stat$deseasrt,method="spearman",use="p")
	datastatm$Meanrl[i]=mean(stat$Corrupted,na.rm=TRUE)
	datastatm$Meanrld[i]=mean(stat$deseasonrl,na.rm=TRUE)
	datastatm$Sdrl[i]=sd(stat$Corrupted,na.rm=TRUE)
	datastatm$RMSErl[i]=rmse(stat$Corrupted,stat$Cleanm,na.rm=TRUE)
	datastatm$Correlationsrl[i]=cor(stat$deseasoncl,stat$deseasonrl,method="spearman",use="p")
}

# The bias itself can be calculated by looking at the differences in the means of the two series (here I am looking at the overall mean - not the daily means. Add the bias as a column to the data frame:

datastatm$bias=(datastatm$Mean-datastatm$Meancl)
mean(datastatm$bias) # -0.04044341
median(datastatm$bias) # -0.01788591
datastatm$biasrl=(datastatm$Meanrl-datastatm$Meancl)

# The means of the deasonalised series should always be zero (because of how the deseasonalisation took place), but check this as a sanity check!

summary(datastatm$Meand-datastatm$Meancld)
summary(datastatm$Meanrld-datastatm$Meancld)

# Rename these data frames to allow them to be used in conjunction with other methods:

dataran1cldse1=dataran1
datarancldse1=dataran
climdse1statm=datastatm

save(datarancldse1,dataran1cldse1,climdse1statm,file='Climatol_daily_analysis_datasets_se1_3915.RData')

## If starting from here can read in these dataframes - though will want to rename them to what they were before so that all the code works (this means there is less possibility for mistakes when running the code for multiple algorithms as there are less things that need to be changed, but there are enough that you shouldn't be able to attribute one algorithm to another algorithm's abilities):

load('Climatol_daily_analysis_datasets_se1_3915.RData')

dataran1=dataran1cldse1
dataran=datarancldse1
datastatm=climdse1statm

######## GROUPING STATIONS INTO THOSE THAT WERE GOOD AND THOSE THAT WERE BAD - THOSE WITH THE 10 HIGHEST RMSE (BETWEEN CLEAN AND RELEASED) ARE CONSIDERED THE WORST, THOSE WITH THE 10 LOWEST RMSES ARE CONSIDERED THE BEST. THESE BEST AND WORST SPLITS WERE NOT CONSIDERED IN THE PAPER, BUT WERE IN THE THESIS. ################

load('Best_and_worst_stations_in_SE.RData')

best=datastatm[c(bestsew1$Station),]; range(best$RMSErl) # (0,0.028)
worst=datastatm[c(worstsew1$Station),]; range(worst$RMSErl) # (1.35,3.06)

### BIAS ##############################################################

# Look at how many stations were positively, negatively, or un-biased on release:
dim(datastatm[datastatm$biasrl > 0,]) # 64 positively biased
dim(datastatm[datastatm$biasrl < 0,]) # 86 negatively biased
dim(datastatm[datastatm$biasrl == 0,]) # 3 un-biased

# Look at how many stations were positively, negatively or un-biased on return:

dim(datastatm[datastatm$bias > 0,]) # 47 positively biased
summary(datastatm[datastatm$bias > 0,]) # mean bias 0.03 and median bias 0.02 max 0.09
dim(datastatm[datastatm$bias < 0,]) # 103 negatively biased
summary(datastatm[datastatm$bias < 0,]) # mean bias -0.08 and median bias -0.04 max -1.07
dim(datastatm[datastatm$bias == 0,]) # 3 unbiased (because they were still perfect) - which means that 0 perfect station was corrupted

# Have a look how many of these have absolute biases <0.05 (i.e., that would be rounded to zero with current measurement precision):

gr0=datastatm[abs(datastatm$bias)<0.05,];nrow(gr0) # 105 stations have a returned absolute bias that is less than 0.05
nrow(gr0[gr0$bias<0,]) # 67 were slightly negatively biased
nrow(gr0[gr0$bias>0,]) # 35 were slightly positively biased (and three were completely unbiased)

nrow(gr0[abs(gr0$biasrl)<0.05,]) # Of these 43 started off with a bias < 0.05
dim(datastatm[abs(datastatm$biasrl)<0.05,]) # 44 were biased by less than 0.05 - This means one un-biased station was made biased.
dim(datastatm[datastatm$biasrl > 0.05,]) # 49 were biased by more than 0.05
dim(datastatm[datastatm$biasrl < -0.05,]) # 60 were biased by more than -0.05

#### Could also look at the sum of the biases ##################

sum(datastatm$biasrl) # -11.9574
sum(datastatm$bias) # -6.187841

#### And can look at the sum of absolute biases ##############

sum(abs(datastatm$biasrl)) # 55.82155
sum(abs(datastatm$bias)) # 9.309228

# Bias plot with released series standard deviation and returned series standard dev and the returned and released region mean bias with dashed black and red lines respectively:

sdb=sd(datastatm$bias);sdb # 0.1250372
sdbrl=sd(datastatm$biasrl);sdbrl # 0.6020926
mnb=mean(datastatm$bias);mnb # -0.04044341
mnbrl=mean(datastatm$biasrl);mnbrl # -0.07815293

plot(datastatm$biasrl,col="red",pch=19,xlab="Station",ylab=expression(paste("Bias (",degree,"C)")),main='',cex=2)
points(datastatm$bias,pch=19,cex=2)
abline(h=0,lwd=3)
abline(h=c(-sdbrl+mnbrl,sdbrl+mnbrl),col="red",lty=2) 
abline(h=mnb,lty=1,lwd=3)
abline(h=mnbrl,lty=1,col="red",lwd=3)
abline(h=c(mnb-sdb,mnb+sdb),lwd=3,lty=2)
legend(-2,-0.9,pch=c(19,19,NA,NA,NA,NA),lty=c(NA,NA,1,1,2,2),col=c('red','black','red','black','red','black'),cex=1.9,legend=c('Released bias','Returned bias',expression(paste('Mean released bias,',mu,'= -0.078')),expression(paste('Mean returned bias,',mu,'=-0.040')),expression(paste('Mean rel bias \u00b1 std.dev -0.078 \u00b1 0.602')),expression(paste('Mean ret bias \u00b1 std.dev -0.040 \u00b1 0.125'))))

# Look at a percentage recovery plot (for all stations, therefore WITHOUT lines or text):

load('Percentage_trend_recovery_function_updated.RData')

ptcplot(rep(0,153),datastatm$biasrl,datastatm$bias,add.text=FALSE,add.segments=FALSE,main='',xlab="Station",ylab=expression(paste("Bias (",degree,"C)")),cex.lab=1.5,cex.axis=1.5,cex.main=1.5)
legend(0,-1,pch=c(4,19,19),col=c('black','red','cornflowerblue'),legend=c('Clean','Released','Climatol-daily')) 

# Produce ptc plots for the best and worst stations as these might be able to be compared across regions - allows you to see at a glance which (if any) of the best and worst stations have been made better or worse:

ptcplot(rep(0,10),best$biasrl,best$bias,add.segments=TRUE,add.text=FALSE,main='',xlab="Station",ylab=expression(paste("Bias (",degree,"C)")),cex.lab=1.5,cex.axis=1.5,cex.main=1.5)
legend(0.2,0.006,pch=c(4,19,19),col=c('black','red','cornflowerblue'),legend=c('Clean','Released','Climatol-daily'),cex=1.5)
# Shows all the best stations had their biases unchanged.

ptcplot(rep(0,10),worst$biasrl,worst$bias,main='',xlab="Station",ylab=expression(paste("Bias (",degree,"C)")),cex.lab=1.5,cex.axis=1.5,cex.main=1.5,add.text=FALSE)
legend(0.5,3,pch=c(4,19,19),col=c('black','red','cornflowerblue'),legend=c('Clean','Released','Climatol-daily'),cex=1.5)
# Shows all the worst stations had their biases improved.

# These plots don't actually save the percentage recovery measures => work them out here:

percentbiasdm=((datastatm$biasrl-datastatm$bias)/(datastatm$biasrl-0)) * 100; stats=datastatm[datastatm$biasrl==0,]; stats1=stats[stats$bias==0,1] # Need which of these values are both zero before executing the next line which gives a 100% PR if an algorithm has correctly not biased a station that was unbiased on release.
percentbiasdm[c(stats1)]=100

length(na.omit(percentbiasdm[percentbiasdm>100 & percentbiasdm<200])) # 35 are improved too far
length(na.omit(percentbiasdm[percentbiasdm>0 & percentbiasdm<100])) # 56 are improved in the right direction, but not far enough 
length(na.omit(percentbiasdm[percentbiasdm==100])) # 3 are unchanged because of perfection
length(na.omit(percentbiasdm[percentbiasdm>200])) # 2 are 'improved' so much that they become more biased than they were before
length(na.omit(percentbiasdm[percentbiasdm<0])) # 5 moved in the wrong direction 
length(na.omit(percentbiasdm[percentbiasdm==0])) # 52 are unchanged 

length(na.omit(percentbiasdm[percentbiasdm>75 & percentbiasdm<125 & percentbiasdm!=100])) # 72 - This is the near perfection table column (greatly improved)
length(na.omit(percentbiasdm[percentbiasdm<75 & percentbiasdm>0])) # 10 - This is my improved column 
length(na.omit(percentbiasdm[percentbiasdm>125 & percentbiasdm<200])) # 9 - This is my number in brackets in my improved column (improved in such a way as to overshoot zero bias)
length(na.omit(percentbiasdm[percentbiasdm==0])) # 52 - This is my unchanged column
length(na.omit(percentbiasdm[percentbiasdm==100])) # 3 - This is the number in brackets in my unchanged column (unchanged because of perfection)
length(na.omit(percentbiasdm[percentbiasdm<0 | percentbiasdm>200])) # 7 - This is the made worse column

# Bias in 'best' stations for returned data (we know this is the same as in the released data):
mean(best$bias) # -0.001
median(best$bias) # -0.001
mean(abs(best$bias)) # 0.003
median(abs(best$bias)) # 0.002

# Bias in the 'worst' stations for released data:
mean(worst$biasrl) # 0.037
median(worst$biasrl) # 0.008
mean(abs(worst$biasrl)) # 1.611
median(abs(worst$biasrl)) # 1.345

# Bias in 'worst' stations for returned data:
mean(worst$bias) # -0.037
median(worst$bias) # -0.041
mean(abs(worst$bias)) # 0.050
median(abs(worst$bias)) # 0.041

# Percentage recoveries for bias in best and worst stats:

percentbiasdm[c(best$Station)] #  100 100 100   0   0   0   0   0   0   0
percentbiasdm[c(worst$Station)] #  99.77054  98.83496  93.58627  96.72689 105.04407  96.53810  99.20392 92.00485  97.55873  98.75799 - All 10 of these would be in GI (greatly improved)

#### RMSE #####

#### Look at a few summary measures for RMSE #############

# Number of perfect stations on release and return:
dim(datastatm[abs(datastatm$RMSErl)==0,]) # 3
dim(datastatm[abs(datastatm$RMSE)==0,]) # 3

# Number of near perfect stations on release and return:
dim(datastatm[abs(datastatm$RMSErl)<0.05,]) # 18
dim(datastatm[abs(datastatm$RMSE)<0.05,]) # 27

mean(datastatm$RMSErl) # 0.498
median(datastatm$RMSErl) # 0.282
mean(datastatm$RMSE) # 0.128
median(datastatm$RMSE) # 0.093

# And in the best and worst stations (will be the same as on release):

mean(best$RMSE) # 0.014
median(best$RMSE) # 0.016
range(best$RMSE) # 0 0.028
sd(best$RMSE) # 0.011

mean(worst$RMSE) # 0.119
median(worst$RMSE) # 0.104
range(worst$RMSE) # 0.038 0.227
sd(worst$RMSE) # 0.066

mean(worst$RMSErl) # 1.82
median(worst$RMSErl) # 1.56
range(worst$RMSErl) # 1.53 3.06
sd(worst$RMSErl) # 0.59

###### We said we could compare algorithms by looking at the sum of RMSEs ##################

sum(datastatm$RMSErl) # 76.14634
sum(datastatm$RMSE) # 19.5558

## Percentage recovery:

percentrmse=((datastatm$RMSErl-datastatm$RMSE)/(datastatm$RMSErl-0)) * 100; stats=datastatm[datastatm$RMSErl==0,]; stats1=stats[stats$RMSE==0,1] # Need which of these values are both zero before executing the next line
percentrmse[c(stats1)]=100

# Looking at what it means as to whether these have been 'improved' or not for RMSE:

length(na.omit(percentrmse[percentrmse>0 & percentrmse!=100])) # 95 are improved 
length(na.omit(percentrmse[percentrmse>0 & percentrmse==100])) # 3 are unchanged because of perfection
length(na.omit(percentrmse[percentrmse<0])) # 3 are moved in the wrong direction 
length(na.omit(percentrmse[percentrmse==0])) # 52 are unchanged 

length(na.omit(percentrmse[percentrmse>75 & percentrmse!=100])) # 56 - This is the near perfection table column = greatly improved (GI)
length(na.omit(percentrmse[percentrmse<75 & percentrmse>0])) # 39 - This is my improved column 
length(na.omit(percentrmse[percentrmse<0])) # 3 - This is the made worse column
length(na.omit(percentrmse[percentrmse==0])) # 52 - This is my unchanged column
length(na.omit(percentrmse[percentrmse==100])) # 3 - This is the number in brackets in my unchanged column

# And doing the same as the above for the 'best' and 'worst' stations:

perbrmse=percentrmse[c(best$Station)]
perwrmse=percentrmse[c(worst$Station)]

length(na.omit(perbrmse[perbrmse>0 & perbrmse!=100])) # 0 are improved
length(na.omit(perbrmse[perbrmse==100])) # 3 remain perfect
length(na.omit(perbrmse[perbrmse<0])) # 0 is moved in the wrong direction 
length(na.omit(perbrmse[perbrmse==0])) # 7 are unchanged without already being perfect

length(na.omit(perwrmse[perwrmse>0 & perwrmse!=100])) # 10 are improved
length(na.omit(perwrmse[perwrmse>100])) # 0 are improved too much
length(na.omit(perwrmse[perwrmse<0])) # 0 are moved in the wrong direction 
length(na.omit(perwrmse[perwrmse==0])) # 0 is unchanged without already being perfect

## Two panel plot as a method measure which was a scatter plot of released and returned on the left and a ptc-style plot - looking at RMSE improvement:

layout(matrix(c(1,2,2), 1, 3, byrow = TRUE))
plot(datastatm$RMSErl,datastatm$RMSE,xlab='',ylab='',ylim=c(min(datastatm$RMSErl,datastatm$RMSE),max(datastatm$RMSErl,datastatm$RMSE)),xlim=c(min(datastatm$RMSErl,datastatm$RMSE),max(datastatm$RMSErl,datastatm$RMSE)),main="(a)",cex.lab=2.5,cex.main=2,cex.axis=2.5,pch=19,cex=2)
rmserl=sqrt((sum((dataran1$Cleanm-dataran1$Corrupted)^2))/nrow(dataran1));rmserl # 0.730
rmsert=sqrt((sum((dataran1$Cleanm-dataran1$Returned)^2))/nrow(dataran1));rmsert # 0.177
points(rmserl,rmsert,col="red",pch=19,cex=2)
mtext(expression(paste("Released RMSE (",degree,"C)")),side=1,line=4,cex=2)
mtext(expression(paste("Returned RMSE (",degree,"C)")),side=2,line=4,cex=2)
abline(0,1)
plot(1:153,percentrmse,xlab='',ylab='',main="(b)",cex.lab=2.5,cex.main=2,cex.axis=2.5,cex=2)
mtext('Station',side=1,line=4,cex=2)
mtext('Percentage recovery',side=2,line=4,cex=2)
points(c(best$Station),percentrmse[c(best$Station)],col="dark green",pch=24,bg="dark green",cex=2)
points(c(worst$Station),percentrmse[c(worst$Station)],col="cornflowerblue",pch=25,bg="cornflowerblue",cex=2)
points(154,((rmserl-rmsert)/(rmserl-0))*100,col="red",pch=19,cex=2) # 75.75
legend(1,20,pch=c(24,25,19),col=c('dark green','cornflowerblue','red'),legend=c('Best stations','Worst stations','Regional average'),cex=2)

### Look at the ptcplots for RMSE as with bias:

# (Can alter ptcplot so that the y axis starts at 0 instead of being symmetrical).

par(mfrow=c(1,1))
ptcplot(rep(0,153),datastatm$RMSErl,datastatm$RMSE,add.text=FALSE,add.segments=FALSE,main='',xlab="Station",ylab=expression(paste("RMSE (",degree,"C)")),cex.lab=1.5,cex.axis=1.5,cex.main=1.5)
legend(0,2.5,pch=c(4,19,19),col=c('black','red','cornflowerblue'),legend=c('Clean','Released','Climatol-daily'),cex=2) 

# Produce ptc plots for the best and worst stations as these might be able to be compared across regions:

ptcplot(rep(0,10),best$RMSErl,best$RMSE,main='',xlab="Station Index",ylab=expression(paste("RMSE (",degree,"C)")),cex.lab=1.5,cex.axis=1.5,add.text=FALSE)
legend(0.25,0.025,pch=c(4,19,19),col=c('black','red','cornflowerblue'),legend=c('Clean','Released','Climatol-daily'),cex=1.5)

perbrmse # 100 100 100   0   0   0   0   0   0   0

ptcplot(rep(0,10),worst$RMSErl,worst$RMSE,main='',xlab="Station Index",ylab=expression(paste("RMSE (",degree,"C)")),cex.lab=1.5,cex.axis=1.5,add.text=FALSE)
legend(0.25,2.2,pch=c(4,19,19),col=c('black','red','cornflowerblue'),legend=c('Clean','Released','Climatol-daily'),cex=1.5) 

perwrmse # 96.20807 97.16322 93.42957 95.47993 92.00556 91.76598 91.70344 89.06191 96.57467 92.72134

###### LOOKING AT SOME OF THESE MEASURES ON A DAY BY DAY BASIS - FOR THE WHOLE TIME SERIES #############################

### Work with the days that are present, but still working on Time not timenew otherwise things won't match up ##### 

# WARNING: This loop takes a long time (about an hour), make sure you save the output as soon as its completed.

climdday=as.data.frame(matrix(nrow=15340,ncol=13))
names(climdday)=c('Time','Nstats','Meancl','Meancld','Sdcl','Meanrl','Meanrld','Sdrl','Meanrt','Meanrtd','Sdrt','RMSErl','RMSErt')

climdday$Time=1:15340

for (i in 1:15340){
	time=dataran1[dataran1$Time==i,]
	climdday$Nstats[i]=nrow(time)	
	climdday$Meancl[i]=mean(time$Cleanm,na.omit=TRUE)
	climdday$Meancld[i]=mean(time$deseasoncl,na.omit=TRUE)
	climdday$Sdcl[i]=sd(time$Cleanm)
	climdday$Meanrl[i]=mean(time$Corrupted,na.omit=TRUE)
	climdday$Meanrld[i]=mean(time$deseasonrl,na.omit=TRUE)
	climdday$Sdrl[i]=sd(time$Corrupted)
	climdday$Meanrt[i]=mean(time$Returned,na.omit=TRUE)
	climdday$Meanrtd[i]=mean(time$deseasrt,na.omit=TRUE)
	climdday$Sdrt[i]=sd(time$Returned)
	climdday$RMSErl[i]=rmse(time$Cleanm,time$Corrupted)
	climdday$RMSErt[i]=rmse(time$Cleanm,time$Returned)
} 

# Give the dataframe a different name for saving so it can be read in with other Climatol-daily outputs if desired:
climatolddayse1=climdday

save(climatolddayse1,file='climatolddayse1.RData')

# If this is the second time through and you have already run and saved the above data load it in and rename it:
load('climatolddayse1.RData')
climdday = climatolddayse1

# Look at plots of RMSE and bias over time (need to do to 2012 as otherwise it counts the first point of 2011 as the point to stop instead of the last point of 2011):

mytsrmserl <- ts(climdday$RMSErl, start=1970, end=2012, frequency=365) # Released RMSE
mytsrmsert <- ts(climdday$RMSErt, start=1970, end=2012, frequency=365) # Returned RMSE
mytsbiasrl <- ts(climdday$Meanrl-climdday$Meancl, start=1970, end=2012, frequency=365) # Released bias
mytsbiasrt <- ts(climdday$Meanrt-climdday$Meancl, start=1970, end=2012, frequency=365) # Returned bias
mytsmeancl <- ts(climdday$Meancl, start=1970, end=2012, frequency=365) # Clean mean
mytsmeanrl <- ts(climdday$Meanrl, start=1970, end=2012, frequency=365) # Released mean
mytsmeanrt <- ts(climdday$Meanrt, start=1970, end=2012, frequency=365) # Returned mean 
mytssdrl <- ts(climdday$Sdrl/climdday$Sdcl, start=1970, end=2012, frequency=365) # Ratio of clean to released standard deviation
mytssdrt <- ts(climdday$Sdrt/climdday$Sdcl, start=1970, end=2012, frequency=365) # Ration of clean to returned standard deviation
mysdcl <- ts(climdday$Sdcl, start=1970, end=2012, frequency=365) # Clean standard deviation 
mysdrl <- ts(climdday$Sdrl, start=1970, end=2012, frequency=365) # Released standard deviation
mysdrt <- ts(climdday$Sdrt, start=1970, end=2012, frequency=365) # Returned standard deviation

plot(mytsrmserl,main='',col="red",xlab="Year",ylab=expression(paste("RMSE (",degree,"C)")),ylim=c(0,1.1))
points(mytsrmsert,type="l")
s=seq(1970,2012,by=1)
abline(v=s,lty=2,col="gray") # Oddity in 2011.

plot(mytsbiasrl,main="",col="red",xlab="Year",ylab=expression(paste("Bias (",degree,"C)")),ylim=c(-0.3,0.1))
points(mytsbiasrt,type="l")
s=seq(1970,2012,by=1)
abline(v=s,lty=2,col="gray")  

plot(abs(mytsbiasrl),main="",col="red",xlab="Year",ylab=expression(paste("Bias (",degree,"C)")),ylim=c(0,0.3))
points(abs(mytsbiasrt),type="l")
s=seq(1970,2012,by=1)
abline(v=s,lty=2,col="gray")
abline(h=c(0.05),lty=2,col="cornflowerblue") # The blue dashed line is at 0.05 => anything below this line would be rounded to zero at 0.1 degree precision. Can see seasonality. 

plot(abs(mytssdrl),main="Ratio of standard deviations on any given day in South East scenario 1, red = released/clean, black = returned/clean for Climatol-daily",col="red",xlab="Year",ylab=expression(paste("Ratios of standard deviation (",degree,"C)")),ylim=c(0.93,2.2))
points(abs(mytssdrt),type="l")
s=seq(1970,2012,by=1)
abline(v=s,lty=2,col="gray") # Can see standard deviations are much more similar on return than release.

### Look at the difference of the two time series to see whether the amount it is improved by is relatively constant:

plot(mytsrmserl-mytsrmsert,main="Difference in RMSE on any given day in South East scenario 1, released minus returned - for Climatol-Daily",xlab="Year",ylab=expression(paste("Difference in RMSE (",degree,"C)")))
s=seq(1970,2012,by=1)
abline(v=s,lty=2,col="gray")
abline(h=0,col="red") # Gets smaller over time - this makes sense as there will be fewer inhomogeneities to have corrected for later in the time series.

plot(abs(mytsbiasrl)-abs(mytsbiasrt),main="Difference in absolute bias on any given day in South East world 1, released minus returned for Climatol-Daily",xlab="Year",ylab=expression(paste("Difference in absolute bias (",degree,"C): (released minus retured)")))
s=seq(1970,2012,by=1)
abline(v=s,lty=2,col="gray")
abline(h=0,col="red") 

# Have a look at the mean time series too:

### It's pretty messy if you look at days - and ts can't cope with splitting up the time series in intervals that weren't already there, therefore if you want to plot yearly data you have to first average to the yearly level (and it would be the same with months), looking yearly would lose any seasonality.

# This should take less than 1 minute to run.

climdmonth=as.data.frame(matrix(nrow=504,ncol=15))
names(climdmonth)=c('Time','Year','Month','Nstats','Meancl','Meancld','Sdcl','Meanrl','Meanrld','Sdrl','Meanrt','Meanrtd','Sdrt','RMSErl','RMSErt')

climdmonth$Year=sort(rep(1970:2011,12))
climdmonth$Month=rep(1:12,42)
climdmonth$Time=1:504

for (i in 1970:2011){
	Year=dataran1[dataran1$Year==i,]
	for (j in 1:12){
		Month=Year[Year$Month==j,]
		climdmonth$Nstats[(i-1970)*12+j]=nrow(Month)
		climdmonth$Meancl[(i-1970)*12+j]=mean(Month$Cleanm)	
		climdmonth$Meancld[(i-1970)*12+j]=mean(Month$deseasoncl)
		climdmonth$Sdcl[(i-1970)*12+j]=sd(Month$Cleanm)
		climdmonth$Meanrl[(i-1970)*12+j]=mean(Month$Corrupted)
		climdmonth$Meanrld[(i-1970)*12+j]=mean(Month$deseasonrl)
		climdmonth$Sdrl[(i-1970)*12+j]=sd(Month$Corrupted)
		climdmonth$Meanrt[(i-1970)*12+j]=mean(Month$Returned)
		climdmonth$Meanrtd[(i-1970)*12+j]=mean(Month$deseasrt)
		climdmonth$Sdrt[(i-1970)*12+j]=sd(Month$Returned)
		climdmonth$RMSErl[(i-1970)*12+j]=rmse(Month$Cleanm,Month$Corrupted)
		climdmonth$RMSErt[(i-1970)*12+j]=rmse(Month$Cleanm,Month$Returned)
	}
}

# Save this dataframe as you may want to use some of the columns when doing comparisons across regions (rename first to allow this):

climatoldmonthse1=climdmonth

save(climatoldmonthse1,file='climatoldmonthse1.RData')

# Look at time series plots of these values (don't actually need to turn them into R recognised time series),the first two of these plots were included in the report given to homogenisers:

plot(seq(1970,2012,length=504),climdmonth$RMSErl[1:504],main="RMSE in any given month in South East scenario 1, red = released, black = returned \n for Climatol-Daily",col="red",xlab="Year",ylab=expression(paste("RMSE (",degree,"C)")),type="l")
points(seq(1970,2012,length=504),climdmonth$RMSErt[1:504],type="l")
s=seq(1970,2012,by=1)
abline(v=s,lty=2,col="gray")
legend(1990,1,col=c('red','black'),lwd=2,cex=2,legend=c('Released RMSE','Returned RMSE'),bg='white')

plot(seq(1970,2012,length=504),(climdmonth$Meanrl[1:504]-climdmonth$Meancl[1:504]),main="Bias in any given month in South East scenario 1, red = released, black = returned \n for Climatol-Daily",col="red",xlab="Year",ylab=expression(paste("Bias (",degree,"C)")),type="l",lwd=2)
points(seq(1970,2012,length=504),(climdmonth$Meanrt[1:504]-climdmonth$Meancl[1:504]),type="l",lwd=2)
s=seq(1970,2012,by=1)
abline(v=s,lty=2,col="gray") 
abline(h=0,col="red")

plot(seq(1970,2012,length=504),abs(climdmonth$Meanrl[1:504]-climdmonth$Meancl[1:504]),main="Absolute bias in any given month in South East scenario 1, red = released, black = returned \n for Climatol-Daily",col="red",xlab="Year",ylab=expression(paste("Absolute bias (",degree,"C)")),type="l",lwd=2)
points(seq(1970,2012,length=504),abs(climdmonth$Meanrt[1:504]-climdmonth$Meancl[1:504]),type="l",lwd=2)
s=seq(1970,2012,by=1)
abline(v=s,lty=2,col="gray") 
legend(1990,0.20,col=c('red','black'),lwd=2,cex=2,legend=c('Released absolute bias','Returned absolute bias'),bg='white') 

## Create bias and standard deviation ratio columns in the data frame:

climdmonth$biasrl=climdmonth$Meanrl-climdmonth$Meancl
climdmonth$biasrt=climdmonth$Meanrt-climdmonth$Meancl
climdmonth$Sdsdrl=climdmonth$Sdrl/climdmonth$Sdcl
climdmonth$Sdsdrt=climdmonth$Sdrt/climdmonth$Sdcl

plot(seq(1970,2012,length=504),climdmonth$Sdsdrl[1:504],main="Ratio of standard deviations in any given month in South East scenario 1, red = released/clean, black = returned/clean for Climatol-Daily",col="red",xlab="Year",ylab=expression(paste("Ratio of standard deviations (",degree,"C)")),type="l",ylim=c(0.99,1.5))
points(seq(1970,2012,length=504),climdmonth$Sdsdrt[1:504],type="l")
s=seq(1970,2012,by=1)
abline(v=s,lty=2,col="gray") 
legend(1991,1.5,col=c('red','black'),lwd=2,cex=1.5,legend=c('Released/clean standard deviations','Returned/clean standard deviations'),bg='white') # The variability matches better in winter than in summer, but it has still been improved in summer.

# Now look at the difference plots as with the daily data, less variability makes these easier to interpret:

plot(seq(1970,2012,length=504),climdmonth$RMSErl[1:504]-climdmonth$RMSErt[1:504],main="Difference in RMSE in any given month in South East scenario 1, released minus returned \n for Climatol-Daily",xlab="Year",ylab=expression(paste("Difference in RMSE (",degree,"C)")),type='l')
s=seq(1970,2012,by=1)
abline(v=s,lty=2,col="gray") 
abline(h=0,col="red")

plot(seq(1970,2012,length=504),abs(climdmonth$Meanrl[1:504]-climdmonth$Meancl[1:504])-abs(climdmonth$Meanrt[1:504]-climdmonth$Meancl[1:504]),main="Difference in absolute bias in any given month in South East scenario 1, released minus returned \n for Climatol-Daily",xlab="Year",ylab=expression(paste("Difference in absolute bias (",degree,"C)")),type='l')
s=seq(1970,2012,by=1)
abline(v=s,lty=2,col="gray") 
abline(h=0,col="red")

## Also want aggregated plots for the whole year - aggregating the days/ months to form just a single year and plotting this - working with non-deseasonalised data because all the days of the year will have good days and bad days (roughly) so the average performance on an average of all the same day of the year should be fair.

climdday1=as.data.frame(matrix(nrow=366,ncol=13))
names(climdday1)=c('Dyear','Nstats','Mencl','Meancl','Sdcl','Menrl','Meanrl','Sdrl','Menrt','Meanrt','Sdrt','RMSErl','RMSErt')

climdday1$Dyear=1:366 

# This loop only takes a few minutes:

for (i in 1:366){
	time=dataran1[dataran1$Dyear==i,]
	climdday1$Nstats[i]=nrow(time)
	climdday1$Mencl[i]=mean(time$Cleanm)
	climdday1$Meancl[i]=mean(time$deseasoncl)
	climdday1$Sdcl[i]=sd(time$Cleanm)
	climdday1$Menrl[i]=mean(time$Corrupted)
	climdday1$Meanrl[i]=mean(time$deseasonrl)
	climdday1$Sdrl[i]=sd(time$Corrupted)
	climdday1$Menrt[i]=mean(time$Returned)
	climdday1$Meanrt[i]=mean(time$deseasrt)
	climdday1$Sdrt[i]=sd(time$Returned)
	climdday1$RMSErl[i]=rmse(time$Cleanm,time$Corrupted)
	climdday1$RMSErt[i]=rmse(time$Cleanm,time$Returned)
}

# Now account for the leap year:

climdday1[61:366,]=climdday1[60:365,]

i=60 # Need to remember that in this dataframe leap years are indexed as day 60 and not day 59.5
time=dataran1[dataran1$Dyear==59.5,]
climdday1$Nstats[i]=nrow(time)	
climdday1$Mencl[i]=mean(time$Cleanm)
climdday1$Meancl[i]=mean(time$deseasoncl)
climdday1$Sdcl[i]=sd(time$Cleanm)
climdday1$Menrl[i]=mean(time$Corrupted)
climdday1$Meanrl[i]=mean(time$deseasonrl)
climdday1$Sdrl[i]=sd(time$Corrupted)
climdday1$Menrt[i]=mean(time$Returned)
climdday1$Meanrt[i]=mean(time$deseasrt)
climdday1$Sdrt[i]=sd(time$Returned)
climdday1$RMSErl[i]=rmse(time$Cleanm,time$Corrupted)
climdday1$RMSErt[i]=rmse(time$Cleanm,time$Returned)

climdday1$Sdsdrl=climdday1$Sdrl/climdday1$Sdcl
climdday1$Sdsdrt=climdday1$Sdrt/climdday1$Sdcl

# Rename and save:
climdday1se1=climdday1

save(climdday1se1,file='climdday1se1.RData')

# Now look at the plots:

plot(climdday1$Menrl-climdday1$Mencl,type="l",main="Average bias on each day of the year in South East scenario 1\n for released (red) and returned (black) series - Calculated for Climatol-Daily",ylab='',xlab='',col="red",ylim=c(-0.1,0.1))
lines(climdday1$Menrt-climdday1$Mencl) 
lines((climdday1$Menrl-climdday1$Mencl)-(climdday1$Menrt-climdday1$Mencl),col='cornflowerblue') 
mtext('Day of the year',side=1,line=3,cex=2)
mtext(expression(paste("Bias (",degree,"C)")),side=2,line=3,cex=2) 
legend(0,0.1,lty=c(1,1,1),col=c('red','black','cornflowerblue'),legend=c('Released bias','Returned bias','Released minus returned bias'),cex=2) # Bias is being reduced by about the same amount throughout the year - perhaps a little more in northern hemisphere winter

plot(climdday1$RMSErl,type="l",main="RMSE on each day of the year in South East scenario 1 \n for released (red) and returned (black) series - Calculated for Climatol-Daily",ylim=c(0,max(climdday1$RMSErl)),ylab='',xlab='',col="red")
lines(climdday1$RMSErt) 
lines(climdday1$RMSErl-climdday1$RMSErt,col='cornflowerblue') 
mtext('Day of the year',side=1,line=3,cex=2)
mtext(expression(paste("RMSE (",degree,"C)")),side=2,line=3,cex=2) 
legend(0,0.5,lty=c(1,1,1),col=c('red','black','cornflowerblue'),legend=c('Released RMSE','Returned RMSE','Released minus returned RMSE'),cex=2) # RMSE best reduced in spring and autumn

# And for absolute bias:

plot(abs(climdday1$Menrl-climdday1$Mencl),type="l",main="Average absolute bias on each day of the year in South East scenario 1 \n for released (red) and returned (black) series - Calculated for Climatol-Daily",ylab='',xlab='',col="red",ylim=c(-0.1,0.1))
lines(abs(climdday1$Menrt-climdday1$Mencl)) 
lines(abs(climdday1$Menrl-climdday1$Mencl)-abs(climdday1$Menrt-climdday1$Mencl),col='cornflowerblue') 
mtext('Day of the year',side=1,line=3,cex=2)
mtext(expression(paste("Absolute bias (",degree,"C)")),side=2,line=3,cex=2) 
legend(0,-0.05,lty=c(1,1,1),col=c('red','black','cornflowerblue'),legend=c('Released absolute bias','Returned absolute bias','Released minus returned absolute bias'),cex=2)

# And for the standard deviations:

par(mfrow=c(1,2))
plot(climdday1$Sdsdrl,type="l",main="Average ratio of standard deviations on each day of the year in South East scenario 1 \n for released (red) and returned (black) series - Calculated for Climatol-Daily",ylab='',xlab='',col="red",ylim=c(0.998,1.25))
lines(climdday1$Sdsdrt) 
mtext('Day of the year',side=1,line=3,cex=2)
mtext("Standard deviation ratios",side=2,line=3,cex=2) 
legend(0,1.25,lty=c(1,1),col=c('red','black'),legend=c('Released / clean standard deviations','Returned / clean standard deviations'),cex=2)  # Shows the standard deviations were increased a lot more in summer from clean to released and were successfully reduced again from released to returned.
plot(climdday1$Sdsdrl-climdday1$Sdsdrt,type="l",main="Difference in standard deviation ratios on each day of the year in South East scenario 1 \n for released minus returned series - Calculated for Climatol-Daily",ylab='',xlab='') 
mtext('Day of the year',side=1,line=3,cex=2)
mtext("Difference in standard deviation ratios",side=2,line=3,cex=2)

### Trends ###

#### Look at fitting a linear model to the yearly level to reduce the autocorrelation in the data:

# First need to get a year indicator into dataran (need to use dataran, the data with missing values, becuase otherwise will be trying to fit linear trends to data that has been joined up at the gaps)

load('wyupdatefeb29gam.RData')

stat1old=wyupdatefeb29gam[wyupdatefeb29gam$Station==1,] # Get a year reference

dataran$Year=stat1old$Year

# Set up some yearly dataframes (nyears by nstations plus 1):

yearcl=as.data.frame(matrix(nrow=42,ncol=154))
yearcl[,154]=1:42
yearco=as.data.frame(matrix(nrow=42,ncol=154))
yearco[,154]=1:42
yearrm=as.data.frame(matrix(nrow=42,ncol=154))
yearrm[,154]=1:42

# Want to work with deseasonalised data, so find the appropriate deseasonalised data columns in dataran:

m=which(colnames(dataran)=="deseasoncl")
m1=which(colnames(dataran)=="deseasonrl")
m2=which(colnames(dataran)=="deseasrt")

# Now loop over stations and years to get a mean (deseasonalised) temperature value for each year - this takes less than a minute to run:

for(j in 1:153){
	stat=dataran[dataran$Station==j,]
	for(i in 1:42){
	yearcl[i,j]=mean(stat[stat$Year==(i+1969),m],na.rm=TRUE) # deseasoncl
	yearco[i,j]=mean(stat[stat$Year==(i+1969),m1],na.rm=TRUE) # deseasonrl
	yearrm[i,j]=mean(stat[stat$Year==(i+1969),m2],na.rm=TRUE) # deseasrt	
	}
}

# Now store the least squares trends when the data have been aggregated to the yearly levels:

coeffs2=as.data.frame(matrix(nrow=153,ncol=12))

# Columns are: clean intercept, clean trend, significance of clean trend, adjusted R value for clean data to inform how much variance is being explained, same for released, same for returned.
names(coeffs2)=c('Cl0','Clt','Sigtcl','AdjRcl','Rl0','Rlt','Sigtrl','AdjRrl','Rt0','Rtt','Sigtrt','AdjRrt')

for (i in 1:153){
	par(mfrow=c(1,3))
	model=lm(yearcl[,i]~(yearcl[,154]))
	coeffs2[i,1]=model$coefficients[1]
	coeffs2[i,2]=model$coefficients[2]
	coeffs2[i,3]=summary(model)$coefficients[2,4]
	coeffs2[i,4]=summary(model)$adj.r.squared
	plot(model,which=5,main=paste('Station',i))
	model=lm(yearco[,i]~yearco[,154])
	coeffs2[i,5]=model$coefficients[1]
	coeffs2[i,6]=model$coefficients[2]
	coeffs2[i,7]=summary(model)$coefficients[2,4]
	coeffs2[i,8]=summary(model)$adj.r.squared
	plot(model,which=5)
	model=lm(yearrm[,i]~yearrm[,154])
	coeffs2[i,9]=model$coefficients[1]
	coeffs2[i,10]=model$coefficients[2]
	coeffs2[i,11]=summary(model)$coefficients[2,4]
	coeffs2[i,12]=summary(model)$adj.r.squared
	plot(model,which=5)
	Sys.sleep(2) # Makes the system pause long enough to look at the plots before they are overwritten - as there are 153 stations in this region this will take approximately 5 minutes to loop through them all.
} 

# Can check to see if any of the points being used to make the linear models are overly infulential (high leverage and in Cook's distance): REMEMBER WHEN LOOKING AT THE SAME REGION FOR OTHER ALGORITHMS YOU ONLY NEED TO LOOK FOR INFLUENTIAL POINTS IN THE RETURNED DATA AS THE RELEASED AND THE CLEAN WILL BE THE SAME AS HERE

# Influential points are:

# Station 5 - year 41 (2010)
# Station 35 - year 42 (in released)
# Station 43 - year 41 (just in released data)
# Station 45 - year 40 (in clean, released and returned)
# Station 56 - year 41 (just in released data)
# Station 95 - year 37 (in clean, released and returned)
# Station 105 - year 41 (just in released data)
# Station 117 - year 1 (just in released data)
# Station 137 - year 41 (just in released data)

# Want to store the ptc values:

for (i in 1:153){
	coeffs2$ptr[i]=((coeffs2$Rlt[i]*10-coeffs2$Rtt[i]*10)/(coeffs2$Rlt[i]*10-coeffs2$Clt[i]*10))*100
}

coeffs2[c(stats1),]

# IMPORTANT: ONLY execute this line if the above line shows that clean released and returned trends are all the same:
coeffs2$ptr[c(stats1)]=100   

coeffs2$Station=1:153

# Want to save coefficeint data frame in case wanted for comparisons in another context ( => give them distinctive names first):

coeffsclimdsew1=coeffs2

save(coeffsclimdsew1,file='Climatold_yearly_linear_trends_sew1.RData')

# If starting from this line:

load('Climatold_yearly_linear_trends_sew1.RData')

coeffs2=coeffsclimdsew1 

# Look at the ranges of adjusted R-squared values from these models:

summary(coeffs2$AdjRrt) # (-0.025,0.229)

# Look at the ranges of trends at the yearly level (and the decadal level by multiplying by 10):

summary(coeffs2$Rtt) # (-0.009,0.020), decadal (-0.089,0.197), mean decadal = 0.063, median decadal = 0.063

# Look at how many postive and negative trends there are:

dim(coeffs2[coeffs2$Rtt>0,]) # 143 postive trends 
m2=which(colnames(coeffs2)=="Rtt")
summary(coeffs2[coeffs2$Rtt>0,m2]) # Mean trend 0.069 degrees/decade, median trend 0.066
dim(coeffs2[coeffs2$Rtt<0,]) # 10 negative trends 
summary(coeffs2[coeffs2$Rtt<0,m2]) # mean trend -0.025 and median trend -0.016 degrees/decade => no stations with no trend at all

# And look at how many of these trends are significant:

dim(coeffs2[coeffs2$Sigtcl < 0.05,]) # 4
dim(coeffs2[coeffs2$Sigtrl < 0.05,]) # 68
dim(coeffs2[coeffs2$Sigtrt < 0.05,]) # 9

# Name the dataframe that is for the significant linear trends at the yearly level:

sigly=coeffs2[coeffs2$Sigtcl < 0.05,]; sigly$Station # 16 17 35 69
siglyrl=coeffs2[coeffs2$Sigtrl < 0.05,]
siglyrt=coeffs2[coeffs2$Sigtrt < 0.05,]; siglyrt$Station # 1   3  16  17  35  63 102 109 116

sigrt=subset(siglyrt, !(Station %in% siglyrl$Station)); sigrt # Station 3 has a significant trend in the returned series, but not in the released.
sigrt1=subset(siglyrt, !(Station %in% sigly$Station)); sigrt1$Station #   1   3  63 102 109 116 are the stations that have significant trends in the returned series and not the clean series 
sig=subset(siglyrl, (Station %in% sigly$Station))
subset(sig,(Station %in% siglyrt$Station))$Station # 16, 17 and 35 station are significant in clean, released and returned.

# Do a percentage trend recovery plot on just these stations with a significant linear trend in the clean series (remembering that at the moment they're at the yearly not the decadal level and must therefore be multiplied by 10 to get decadal trends)

par(mfrow=c(1,1))
ptcplot(sigly$Clt*10,sigly$Rlt*10,sigly$Rtt*10,main="Percentage trend recovery plot for Climatol-Daily for the stations with significant linear trend in the clean series in South East scenario 1",cex.main=1,cex.lab=2,cex.axis=2,xlab="Index")
legend(0.5,1,pch=19,col=c('black','red','cornflowerblue'),legend=c('Clean','Released','Returned'),cex=2) # xlab is Index - 3 out of 4 have been improved

# Work out the difference in trends between the series that were significant in the clean data and their counterparts in the released and returned data:

sigly$diffrlt=sigly$Clt-sigly$Rlt 
sigly$diffrtt=sigly$Clt-sigly$Rtt

# Work out if any of the returned trends in the significant stations are the same to within 0.05 degrees/decade:

dim(sigly[abs(sigly$diffrlt*10)<0.05,]) # 2
dim(sigly[abs(sigly$diffrtt*10)<0.05,]) # 4

# And do the same for the stations that have a significant trend in the returned series, but not in the clean series:

ptcplot(sigrt1$Clt*10,sigrt1$Rlt*10,sigrt1$Rtt*10,main="Percentage trend recovery plot for Climatol-Daily for the stations with significant linear trends in the returned series in South East scenario 1 \n where the corresponding trend in the clean series is not significant",cex.main=1,cex.lab=2,cex.axis=2,xlab="Index",cex=2,add.text=FALSE)
legend(0.5,0.3,pch=c(4,19,19,NA,NA,NA),lty=c(NA,NA,NA,1,1,6),lwd=c(NA,NA,NA,4,4,4),col=c('black','red','cornflowerblue','black','red','red'),legend=c('Clean','Released','Returned','100% PR','0% PR','200% PR'),cex=2) # 3 stations have been improved and three are unchanged 

# Create percentage trend recovery plots for all stations, for the 10 best and the 10 worst:

ptcplot(coeffs2$Clt*10,coeffs2$Rlt*10,coeffs2$Rtt*10,add.text=FALSE,add.segments=FALSE,main='Percentage recovery of decadal trends for Climatol-Daily on South East scenario 1',xlab="Station",cex.lab=2,cex.axis=2, cex.main=1)
legend(60,-0.5,pch=c(4,19,19),col=c('black','red','cornflowerblue'),legend=c('Clean','Released','Climatol-Daily'),cex=2) # Really nice plot to show the reduction in trend severity. 

besttr=coeffs2[c(best$Station),]
worsttr=coeffs2[c(worst$Station),]

ptcplot(besttr$Clt*10,besttr$Rlt*10,besttr$Rtt*10,main='Percentage recovery of decadal trends for Climatol-Daily on South East scenario 1\'s best stations',xlab="Station Index",cex.lab=2,cex.axis=2, cex.main=1,add.text=FALSE)
legend(4,0.24,pch=c(4,19,19,NA,NA,NA),lty=c(NA,NA,NA,1,1,6),lwd=c(NA,NA,NA,4,4,4),col=c('black','red','cornflowerblue','black','red','red'),legend=c('Clean','Released','Returned','100% PR','0% PR','200% PR'),pt.cex=c(3,3,2,NA,NA,NA),cex=2)
besttr$ptr #   100 100 100   0   0   0   0   0   0   0

ptcplot(worsttr$Clt*10,worsttr$Rlt*10,worsttr$Rtt*10,main='Percentage recovery of decadal trends for Climatol-Daily on South East scenario 1\'s worst stations',xlab="Index",cex.lab=2,cex.axis=2, cex.main=1,cex=1.75,add.text=FALSE,ymax1=1.75)
legend(0.5,1.75,pch=c(4,19,19,NA,NA,NA),lty=c(NA,NA,NA,1,1,6),lwd=c(NA,NA,NA,4,4,4),col=c('black','red','cornflowerblue','black','red','red'),legend=c('Clean','Released','Returned','100% PR','0% PR','200% PR'),pt.cex=c(3,3,2,NA,NA,NA),cex=2)
axis(side=1,at=c(1,2,3,4,5,6,7,8,9,10))
worsttr$ptr # 104.88989  99.07096  94.86075  97.54079  94.00364  99.94605 107.29837 97.44072  94.92367  96.34220

# Look at how many stations fall into each category:

dim(na.omit(coeffs2[coeffs2$ptr>100 & coeffs2$ptr <200,])) # 43 move the station trend too far in the right direction
dim(na.omit(coeffs2[coeffs2$ptr>200,])) # 0 stations have been moved so far in the right direction that they become more wrong than they were before.
dim(na.omit(coeffs2[coeffs2$ptr<0,])) # 2 move the station trend in the wrong direction 
dim(na.omit(coeffs2[coeffs2$ptr > 0 & coeffs2$ptr <100,])) # 53 move the trend in the right direction, but not far enough
dim(na.omit(coeffs2[coeffs2$ptr ==100,])) # 3 are unchanged from perfection
dim(na.omit(coeffs2[coeffs2$ptr ==0,])) # Which means there are 52 where the trend is unchanged.

dim(na.omit(coeffs2[coeffs2$ptr>75 & coeffs2$ptr<125 & coeffs2$ptr!=100,])) # 70 - This is the near perfection table column
dim(na.omit(coeffs2[coeffs2$ptr<75 & coeffs2$ptr>0,])) # 12 - This is my improved column 
dim(na.omit(coeffs2[coeffs2$ptr>125 & coeffs2$ptr<200,])) # 14 - This is my number in brackets in my improved column
dim(na.omit(coeffs2[coeffs2$ptr<0 | coeffs2$ptr>200,])) # 2 - This is the made worse column
dim(na.omit(coeffs2[coeffs2$ptr==0,])) # 52 - This is my unchanged column
dim(na.omit(coeffs2[coeffs2$ptr==100,])) # 3 - This is the number in brackets in my unchanged column

# How many stations are there where the trend is the same in clean and released and returned?

dim(coeffs2[coeffs2$Clt==coeffs2$Rlt & coeffs2$Clt==coeffs2$Rtt,]) # Only the 3 that are perfect

# Calculate the regional averages - these can in part be read in from the following data file as the clean and released regional averages will not change across methods:

load('Regional_averages_SE_world1_Climatolm2.RData')

# Ensure that the numbers saved in this dataframe really are the ones from THIS algorithm:
regave$Returned=NA

# This loop takes about half an hour to run, therefore save once completed:

for (i in 1:15340){
	time=dataran[dataran$Time==i,]
	regave$Returned[i]=mean(time$deseasrt,na.rm=TRUE)
} 

save(regave,file='Regional_averages_SE_world1_Climatold.RData') 

### ONLY WHEN WANTING INFORMATION FROM OBSERVED DATA USED TO BUILD THE MODELS TOO ###

menobs=as.data.frame(matrix(nrow=366,ncol=153))

for (i in 1:153){
	stat=dataran[dataran$Station==i,]
	statn29=stat[stat$Dyear!=59.5,]
	stat29=stat[stat$Dyear==59.5,]
	statarrt=t(array(statn29$TMEAN,dim=c(365,42)))
	menobs[1:59,i]=apply(statarrt[,1:59],2,mean,na.rm=TRUE)
	menobs[61:366,i]=apply(statarrt[,60:365],2,mean,na.rm=TRUE)
	menobs[60,i]=mean(stat29$TMEAN,na.rm=TRUE)
} 

# These lines put the means into dataframes where each column is the mean for each station:

menobs1=rbind(menobs[-60,],menobs[-60,],menobs,menobs[-60,],menobs[-60,],menobs[-60,],menobs,menobs[-60,],menobs[-60,],menobs[-60,],menobs,menobs[-60,],menobs[-60,],menobs[-60,],menobs,menobs[-60,],menobs[-60,],menobs[-60,],menobs,menobs[-60,],menobs[-60,],menobs[-60,],menobs,menobs[-60,],menobs[-60,],menobs[-60,],menobs,menobs[-60,],menobs[-60,],menobs[-60,],menobs,menobs[-60,],menobs[-60,],menobs[-60,],menobs,menobs[-60,],menobs[-60,],menobs[-60,],menobs,menobs[-60,],menobs[-60,],menobs[-60,])
rm(menobs)

# Now I want to create a deseasonalised column in the dataran dataframe:

for (i in 1:153){
	dataran$deseasobs[((i-1)*15340+1):(i*15340)]=dataran$TMEAN[((i-1)*15340+1):(i*15340)]-menobs1[,i]
}

for (i in 1:15340){
	time=dataran[dataran$Time==i,]
	regave$TMEAN[i]=mean(time$deseasobs,na.rm=TRUE)
} # This loops through the dataframe 15340 times (once for each day) which means this takes half an hour, therefore SAVE the results!

save(regave,file='Regional_averages_SE_world1_Climatold_with_observations.RData') 

# If starting from this point load in the previously saved dataframe:
load('Regional_averages_SE_world1_Climatold_with_observations.RData')
load('wyupdatefeb29gam.RData')

stat1old=wyupdatefeb29gam[wyupdatefeb29gam$Station==1,] # Get a year reference

# Add the year reference to the data frame:
regave$Year=stat1old$Year

regavey=as.data.frame(matrix(nrow=42,ncol=4))
regavey[,1]=1970:2011

# Find which columns relate to which data types (this allows the code to be run automatically instead of interactively):
m=which(colnames(regave)=="Clean")
m1=which(colnames(regave)=="Released")
m2=which(colnames(regave)=="Returned")
m3=which(colnames(regave)=="TMEAN")

for(i in 1:42){
	regavey[i,2]=mean(regave[regave$Year==(i+1969),m],na.rm=TRUE) # Clean series
	regavey[i,3]=mean(regave[regave$Year==(i+1969),m1],na.rm=TRUE) # Released series
	regavey[i,4]=mean(regave[regave$Year==(i+1969),m2],na.rm=TRUE) # Returned series
	regavey[i,5]=mean(regave[regave$Year==(i+1969),m3],na.rm=TRUE) # Observed series
}

names(regavey)=c('Time','Clean','Released','Returned','TMEAN')

# The models:

modelcly=lm(regavey$Clean~regavey$Time)
summary(modelcly) # Time isn't significant - it's coefficient is 0.005157 => aggregating this up it's a trend of 0.05157 degrees per decade - adjusted R-squared: 0.0006191, R-squared: 0.02499

modelrly=lm(regavey$Released~regavey$Time)
summary(modelrly) # Time isn't significant - it's coefficient is 0.008719 => aggregating this up it's a trend of 0.08719 degrees per decade - adjusted R-squared: 0.04547, R-squared: 0.06875 

modelrty=lm(regavey$Returned~regavey$Time)
summary(modelrty)# Time isn't significant - it's coefficient is 0.006197  => aggregating this up it's a trend of 0.06197 degrees per decade - adjusted R-squared: 0.01144, R-squared: 0.03555

modelobs=lm(regavey$TMEAN~regavey$Time)
summary(modelobs) # Time isn't significant - it's coefficient is 0.005671  => aggregating this up it's a trend of 0.05671 degrees per decade - adjusted R-squared: 0.0003583, R-squared: 0.02474

par(mfrow=c(1,2))
plot(coeffs2$Clt*10,coeffs2$Rlt*10,main="(a)",xlab="Clean (degrees/decade)",ylab="Released(degrees/decade)",xlim=c(-1.2,1.1),ylim=c(-1.2,1.1),pch=19,cex=2,cex.main=2)
points(modelcly$coefficients[2]*10,modelrly$coefficients[2]*10,col="red",pch=19,cex=2)
points(coeffs2$Clt[c(sigly$Station)]*10,coeffs2$Rlt[c(sigly$Station)]*10,pch=19,cex=2,col="cornflowerblue")
legend(-1.2,1.1,pch=19,col=c('black','red','cornflowerblue'),legend=c('Station trends','Regional average trend','Stations with significant \n trends in the clean data'),cex=1.5)
abline(0,1)
plot(coeffs2$Clt*10,coeffs2$Rtt*10,main="(b)",xlab="Clean (degrees/decade)",ylab="Returned (degrees/decade)",xlim=c(-1.2,1.1),ylim=c(-1.2,1.1),pch=19,cex=2,cex.main=2)
points(modelcly$coefficients[2]*10,modelrty$coefficients[2]*10,col="red",pch=19,cex=2)
points(coeffs2$Clt[c(sigly$Station)]*10,coeffs2$Rtt[c(sigly$Station)]*10,pch=19,cex=2,col="cornflowerblue")
points(coeffs2$Clt[c(siglyrt$Station)]*10,coeffs2$Rtt[c(siglyrt$Station)]*10,pch=4,col="orange",cex=3,lwd=3)
legend(-1.2,1.1,pch=c(19,19,19,4),col=c('black','red','cornflowerblue','orange'),legend=c('Station trends','Regional average trend','Stations with significant \n trends in the clean data','Stations with significant \n trends in the returned data'),cex=1.5)
abline(0,1)

# Get a value for the pecentage trend recovery too (of linear trends from regavey) and do a percentage recovery plot of this information:

((modelrly$coefficients[2]*10-modelrty$coefficients[2]*10)/(modelrly$coefficients[2]*10-modelcly$coefficients[2]*10)) *100 # 70.79

par(mfrow=c(1,1))
ptcplot(modelcly$coefficients[2]*10,modelrly$coefficients[2]*10,modelrty$coefficients[2]*10,main="Percentage trend recovery for the regional average \n of stations in South East scenario 1. Decadal trend calculated from yearly data.",cex.main=1.5,cex.axis=2,cex.lab=2,cex=2) 


### VARIABILITY - STANDARD DEVIATIONS AND EXTREMES ####

#### COMPARING SPREAD USING STANDARD DEVIATIONS ######################

####### Have compared biases (differences in means) - now also want to compare variances (differences in scale) - looking at non-deseasonalised data ###############

# Look at ratios:
sdsdrl=datastatm$Sdrl/datastatm$Sdcl
sdsdrt=datastatm$Sd/datastatm$Sdcl

sdsdrld=datastatm$Sddrl/datastatm$Sddcl
sdsdrtd=datastatm$Sdd/datastatm$Sddcl

par(mfrow=c(1,1))
plot(sdsdrl,col="red",pch=19,xlab="Station",ylab="Standardised standard deviation",main="Standard deviations for each station, Red = Released, Black = Returned \n standardised by the standard deviation of the clean series - for Climatol-Daily",cex=2)
points(sdsdrt,pch=19,cex=2)
abline(h=1,lwd=2)
legend(0,1.04,pch=c(19,19),col=c('red','black'),legend=c('Released/clean standard deviations','Returned/clean standard deviations'),cex=2)

# Look at how many scales have been improved, how many are unchanged and how many are made worse:

# Not deseasonalised
sdnd=as.data.frame(matrix(nrow=153,ncol=3))
sdnd[,1]=sdsdrl
sdnd[,2]=sdsdrt
sdnd[,3]=sdsdrl-sdsdrt
sdnd$ptr=(sdnd[,1]-sdnd[,2])/(sdnd[,1]-1)*100

# The returned series:
length(sdsdrt[sdsdrt>1]) # 97 stations were more variable than clean
length(sdsdrt[sdsdrt==1]) # 3 stations had no change in variability from clean
length(sdsdrt[sdsdrt<1]) # 53 stations were less variable than clean

decd=sdnd[sdnd[,1] < 1 & sdnd[,2] < 1 & sdnd[,3] <0,];dim(decd) # 7 where an improvement has been made to increase the scale and get it closer to clean
dim(decd[decd$ptr>75 & decd$ptr <125,]) # 2 would be classed as GI
dim(decd[decd$ptr <75 & decd$ptr> 0,]) # 5 would be classed as I

dim(sdnd[sdnd[,1] > 1 & sdnd[,2] > 1 & sdnd[,3] <0,]) # 10 where the scale was made larger when it shouldn't have been => MW

decri=sdnd[sdnd[,1] < 1 & sdnd[,2] > 1,]; dim(decri) # 1 where the scale was increased too far in the right direction
dim(decri[decri$ptr>100 & decri$ptr<125,]) # 0 would be classed as GI
dim(decri[decri$ptr>125 & decri$ptr<200,]) # 0 would be classed as I
dim(decri[decri$ptr>200,]) # 1 would be classed as MW

deci=sdnd[sdnd[,1] > 1 & sdnd[,2] > 1 & sdnd[,3] >0,];dim(deci) # 55 where an improvement has been made to decrease the scale and get it closer to clean
dim(deci[deci$ptr>75 & deci$ptr <125,]) # 21 would be classed as GI
dim(deci[deci$ptr <75 & deci$ptr> 0,]) # 34 would be classed as I

dim(sdnd[sdnd[,1] < 1 & sdnd[,2] < 1 & sdnd[,3] >0,]) # 7 where the scale was decreased when it shouldn't have been => MW

decr=sdnd[sdnd[,1] > 1 & sdnd[,2] < 1,]; dim(decr) # 18 where the scale was decreased too far in the right direction
dim(decr[decr$ptr>100 & decr$ptr<125,]) # 12 would be classed as GI
dim(decr[decr$ptr>125 & decr$ptr<200,]) # 4 would be classed as I
dim(decr[decr$ptr>200,]) # 2 would be classed as MW

dim(sdnd[sdnd[,3]==0,]) # 55 where no improvement has been made - of these there were 3 homogeneous stations where no improvement needed to be made

dim(sdnd[sdnd[,3]!=0 & sdnd[,1]==1,]) # 0

summary(sdnd)
# Mean variability ratio in released data 1.0036, median variability ratio in released data 1.0015
# Mean variability ratio in returned data 1.0017, median variability ratio in returned data 1.0004

sdndb=sdnd[c(best$Station),]
summary(sdndb)
# Mean variability ratio in best released data 1.0001, median variability ratio in best released data 1
# Mean variability ratio in best returned data 1.0001, median variability ratio in best returned data 1

sdndw=sdnd[c(worst$Station),]
summary(sdndw)
# Mean variability ratio in worst released data 1.0110, median variability ratio in worst released data 1.0070
# Mean variability ratio in worst returned data 1.0015, median variability ratio in worst returned data 1.0007

## Looking at the ptcplot for the standard deviation ratios:

ptcplot(rep(1,153),sdsdrl,sdsdrt,add.text=FALSE,add.segments=FALSE,main='Percentage recovery of standard deviation ratio for Climatol-Daily on South East scenario 1',xlab="Station",ylab="Standard deviation ratio",cex.lab=1.5,cex.axis=1.5,cex.main=1.5)
legend(0,1.05,pch=c(4,19,19),col=c('black','red','cornflowerblue'),legend=c('Clean','Released','Climatol-Daily'),cex=2) 

# Produce ptc plots for the best and worst stations as these can be compared across regions:

ptcplot(rep(1,10),sdndb[,1],sdndb[,2],add.text=FALSE,add.segments=FALSE,main='Percentage recovery of standard deviation ratio for Climatol-Daily on South East scenario 1\'s best stations',xlab="Station Index",ylab="Standard deviation ratio", cex.lab=1.5, cex.axis=1.5, cex.main=1.5)
legend(0.5,1.0006,pch=c(4,19,19),col=c('black','red','cornflowerblue'),legend=c('Clean','Released','Climatol-Daily'),cex=2) # None of these stations have their standard deviations changed
((sdndb[,1]-sdndb[,2])/(sdndb[,1]-1)*100) #   NaN NaN NaN   0   0   0   0   0   0   0

ptcplot(rep(1,10),sdndw[,1],sdndw[,2],main='Percentage recovery of standard deviation ratio for Climatol-Daily on South East scenario 1\'s worst stations',xlab="Station Index",ylab="Standard deviation ratio", cex.lab=1.5, cex.axis=1.5, cex.main=1.5,add.text=FALSE)
legend(0.5,1.025,pch=c(4,19,19),col=c('black','red','cornflowerblue'),legend=c('Clean','Released','Climatol-Daily'),cex=2)
((sdndw[,1]-sdndw[,2])/(sdndw[,1]-1)*100) #  103.64117 100.40142 139.69769  98.37381  65.59470 110.18480  48.13082  66.69232  95.31788  49.39373

################# Looking at extremes ######################### 

### Looking at days like for like:

extremes2=as.data.frame(matrix(nrow=153,ncol=7))
names(extremes2)=c('Station','Max_clean','Min_clean','Max_rel','Min_rel','Max_ret','Min_ret')
extremes2$Station=1:153

# If the most extreme value occurs on more than one day then it doesn't matter because this code creates subsets of days where the extreme occurs and then looks for the most extreme released and returned values in those subsets.

m=which(colnames(dataran)=="Corrupted")
m1=which(colnames(dataran)=="Returned")

# This takes less than a minute to run:

for (i in 1:153){
	stat=dataran1[dataran1$Station==i,]
	extremes2$Max_clean[i]=max(stat$Cleanm)
	extremes2$Min_clean[i]=min(stat$Cleanm)
	extremes2$Max_rel[i]=max(stat[stat$Cleanm==extremes2$Max_clean[i],m])
	extremes2$Min_rel[i]=min(stat[stat$Cleanm==extremes2$Min_clean[i],m])
	extremes2$Max_ret[i]=max(stat[stat$Cleanm==extremes2$Max_clean[i],m1])
	extremes2$Min_ret[i]=min(stat[stat$Cleanm==extremes2$Min_clean[i],m1])
}

# Creating plots of these to compare the min/max temp on the day of the extreme in the clean world - here the dots are the actual value in released and returned on the day that the most extreme value occurred in the clean series. The dashed lines allow for the uncertainties:

par(mfrow=c(2,2))
plot(extremes2$Max_clean,extremes2$Max_rel,xlab="Clean warm extreme",ylab="Released value on day \n of clean extreme",main='(a)',pch=19,cex=0.7,cex.main=2)
abline(0.14,1,col="red",lty=2)
abline(-0.14,1,col="red",lty=2)
abline(0,1)
plot(extremes2$Max_clean,extremes2$Max_ret,xlab="Clean warm extreme",ylab="Returned value on day \n of clean extreme",main='(b)',pch=19,cex=0.7,cex.main=2)
abline(0.14,1,col="red",lty=2)
abline(-0.14,1,col="red",lty=2)
abline(0,1)
plot(extremes2$Min_clean,extremes2$Min_rel,xlab="Clean cold extreme",ylab="Released value on day \n of clean extreme",main='(c)',pch=19,cex=0.7,cex.main=2)
abline(0.14,1,col="red",lty=2)
abline(-0.14,1,col="red",lty=2)
abline(0,1) 
plot(extremes2$Min_clean,extremes2$Min_ret,xlab="Clean cold extreme",ylab="Returned value on day \n of clean extreme",main='(d)',pch=19,cex=0.7,cex.main=2)
abline(0.14,1,col="red",lty=2)
abline(-0.14,1,col="red",lty=2) 
abline(0,1) 

## Warm extremes clean and released

tewrl=extremes2[extremes2$Max_clean==extremes2$Max_rel,]; dim(tewrl) # 84 days where warm extremes in clean and released match
dim(extremes2[extremes2$Max_clean==extremes2$Max_rel & extremes2$Max_clean==extremes2$Max_ret,]) # 84 of these also match in the returned data

dim(extremes2[extremes2$Max_clean<extremes2$Max_rel,]) # 30 occasions where the released hot extreme was bigger than the clean
dim(extremes2[extremes2$Max_clean>extremes2$Max_rel,]) # 39 occasions where the released hot extreme was smaller than the clean
dim(extremes2[extremes2$Min_clean<extremes2$Min_rel,]) # 36 occasions where the released cold extreme was bigger than the clean
dim(extremes2[extremes2$Min_clean>extremes2$Min_rel,]) # 70 occasions where the released cold extreme was smaller than the clean

dim(extremes2[extremes2$Max_clean==extremes2$Max_ret,]) # 100 days where extremes match exactly between clean and returned

tewrlp=extremes2[extremes2$Max_clean <= (extremes2$Max_rel+0.14) & extremes2$Max_clean >= (extremes2$Max_rel-0.14),]; dim(tewrlp) # 101 out of 153 warm extremes are correct to within 0.14 degrees in the released data
tewrlp1=extremes2[extremes2$Max_clean <= (extremes2$Max_ret+0.14) & extremes2$Max_clean >= (extremes2$Max_ret-0.14),]; dim(tewrlp1) # 134 out of 153 warm extremes are correct to within 0.14 degrees in the returned data
dim(sqldf('SELECT * FROM tewrlp1 EXCEPT SELECT * FROM tewrlp')) # 33 - so of the 134 that are now exact to measurement precision, 33 were not before, which means that 0 were exact to measurement precision before homogenisation, but not after but isn't after.

extremewp=extremes2[(extremes2$Max_clean+0.14) < extremes2$Max_ret,];dim(extremewp) # 6 days where the returned warm extreme is more than 0.14C warmer than in the clean data
dim(extremewp[extremewp$Max_ret==extremewp$Max_rel,]) # 6 of these have been left unchanged
extremewpm=extremewp[extremewp$Max_ret<extremewp$Max_rel,];dim(extremewpm) # 0 of these have been brought down from being even more extreme.

extremewp1=extremewp[extremewp$Max_ret>extremewp$Max_rel,]; dim(extremewp1) # 0 have wrongly been made warmer than in the released data

extremewm=extremes2[(extremes2$Max_clean-0.14) > extremes2$Max_ret,]; dim(extremewm) # 13 days where the warm extreme is more than 0.14 cooler than in the clean data
dim(extremewm[extremewm$Max_ret>extremewm$Max_rel,]) # 4 were made warmer and are therefore better (i.e. it's still cooler than in the clean data, but warmer than it was on release, so therefore closer to the truth).
dim(extremewm[extremewm$Max_ret==extremewm$Max_rel,]) # 9 of these have been left unchanged

extremewmp=extremewm[extremewm$Max_ret<extremewm$Max_rel,]; dim(extremewmp) # 0 were made colder than on release and of these three:

# The following lines are present for when extremewmp has non-zero size:
dim(extremewmp[abs(extremewmp$Max_ret-extremewmp$Max_clean)>abs(extremewmp$Max_rel-extremewmp$Max_clean),]) # 0 were more out than before
dim(extremewmp[abs(extremewmp$Max_ret-extremewmp$Max_clean)==abs(extremewmp$Max_rel-extremewmp$Max_clean),]) # 0 were as out as before
dim(extremewmp[abs(extremewmp$Max_ret-extremewmp$Max_clean)<abs(extremewmp$Max_rel-extremewmp$Max_clean),]) # 0 were better than before! 

# Cold extremes clean and released:

tecrl=extremes2[extremes2$Min_clean==extremes2$Min_rel,]; dim(tecrl) # 47 days where cold extremes in clean and released match
dim(extremes2[extremes2$Min_clean==extremes2$Min_rel & extremes2$Min_clean==extremes2$Min_ret,]) # 47 out of 47 of these match in the returned data too

# These two lines are only necessary if some of the cold extremes that matched in the released data didn't match in the returned.
extremes2[extremes2$Min_clean==extremes2$Min_rel & extremes2$Min_clean < extremes2$Min_ret,] # 0 has been made warmer
extremes2[extremes2$Min_clean==extremes2$Min_rel & extremes2$Min_clean > extremes2$Min_ret,] # 0 has been made cooler

dim(extremes2[extremes2$Min_clean==extremes2$Min_ret,]) # 72 where clean and returned match for cold extremes

tecrlp=extremes2[extremes2$Min_clean >= (extremes2$Min_rel-0.14) & extremes2$Min_clean <= (extremes2$Min_rel+0.14),]; dim(tecrlp) # 67 out of 153 cold extremes are correct to within 0.14 degrees in the released data
tecrlp1=extremes2[extremes2$Min_clean >= (extremes2$Min_ret-0.14) & extremes2$Min_clean <= (extremes2$Min_ret+0.14),]; dim(tecrlp1) # 107 out of 153 cold extremes are correct to within 0.14 degrees in the returned data
dim(sqldf('SELECT * FROM tecrlp1 EXCEPT SELECT * FROM tecrlp')) # 42 - so of the 107 that are now exact to measurement precision, 42 were not before, which means that 2 were exact to measurement precision before but aren't after homogenisation (i.e. they have been made worse).

extremecm=extremes2[(extremes2$Min_clean+0.14) < extremes2$Min_ret,];dim(extremecm) # 16 days where the cold extreme in the returned data is more than 0.14C warmer than in the clean data
dim(extremecm[extremecm$Min_ret==extremecm$Min_rel,]) # 9 of these have been left unchanged
extremecmm=extremecm[extremecm$Min_ret<extremecm$Min_rel,]; dim(extremecmm) # 4 of these are cooler than they were in the released data and of these 4:
dim(extremecmm[abs(extremecmm$Min_ret-extremecmm$Min_clean)>abs(extremecmm$Min_rel-extremecmm$Min_clean),]) # 0 were more out than before
dim(extremecmm[abs(extremecmm$Min_ret-extremecmm$Min_clean)==abs(extremecmm$Min_rel-extremecmm$Min_clean),]) # 0 were as out as before
dim(extremecmm[abs(extremecmm$Min_ret-extremecmm$Min_clean)<abs(extremecmm$Min_rel-extremecmm$Min_clean),]) # 4 were less out than before

extremecm1=extremecm[extremecm$Min_ret>extremecm$Min_rel,]; dim(extremecm1) # 3 of these are warmer than in the released data and of these 3:
dim(extremecm1[abs(extremecm1$Min_ret-extremecm1$Min_clean)>abs(extremecm1$Min_rel-extremecm1$Min_clean),]) # 1 is more out than before
dim(extremecm1[abs(extremecm1$Min_ret-extremecm1$Min_clean)==abs(extremecm1$Min_rel-extremecm1$Min_clean),]) # 0 are as out
dim(extremecm1[abs(extremecm1$Min_ret-extremecm1$Min_clean)<abs(extremecm1$Min_rel-extremecm1$Min_clean),]) # 2 are not as far out as before (they're just in the opposite direction)

extremecp=extremes2[(extremes2$Min_clean-0.14) > extremes2$Min_ret,];dim(extremecp) # 30 days where the cold extreme is more than 0.14C cooler than in the clean data
dim(extremecp[extremecp$Min_ret==extremecp$Min_rel,]) # 15 of these have been left unchanged
extremepm=extremecp[extremecp$Min_ret>extremecp$Min_rel,]; dim(extremepm) # 9 of these are warmer than they were in the released data and of these:
dim(extremepm[abs(extremepm$Min_ret-extremepm$Min_clean)>abs(extremepm$Min_rel-extremepm$Min_clean),]) # 0 were more out than before
dim(extremepm[abs(extremepm$Min_ret-extremepm$Min_clean)==abs(extremepm$Min_rel-extremepm$Min_clean),]) # 0 were as out as before
dim(extremepm[abs(extremepm$Min_ret-extremepm$Min_clean)<abs(extremepm$Min_rel-extremepm$Min_clean),]) # 9 were less out than before

extremecp1=extremecp[extremecp$Min_ret<extremecp$Min_rel,]; dim(extremecp1) # 6 of these are cooler than in the released data
dim(extremecp1[abs(extremecp1$Min_ret-extremecp1$Min_clean)>abs(extremecp1$Min_rel-extremecp1$Min_clean),]) # And 4 are now more out now than before homogenisation
dim(extremecp1[abs(extremecp1$Min_ret-extremecp1$Min_clean)==abs(extremecp1$Min_rel-extremecp1$Min_clean),]) # 0 are as out, but in the other direction 
dim(extremecp1[abs(extremecp1$Min_ret-extremecp1$Min_clean)<abs(extremecp1$Min_rel-extremecp1$Min_clean),]) # 2 are less out

####### DETECTION ABILITY #######

# First load in the dataframe that has information on the inserted breaks - NOT including the breaks that were unidentifiable (these were the breaks that had a relative size of zero between one homogeneous sub-period and the next):

load('Inserted_inhomogeneity_locations_R_readable/SEW1_missing_un.RData') # Inhomogeneitiesia contains info for all the identifiable inhomogeneities in the series and the 7 that start and then continue through the last HSP

# Load the dataframe of detected breaks (created using Formatting_example_Climatol_daily.R):

load('Climatol_daily_SEW1_breaks.RData') # testdat1 is what we're interested in

# Load the dataframes that have CPs and HSPs as windows (in the paper only the 90 day window analysis was used):

load('SE_world1_30_window.RData') # Ih30a2 is what we're interested in 
load('SE_world1_90_window.RData') # Ih90a2 is what we're interested in

# If everything is windowed and each window counts once towards a, b, c or d then employ the following script:

for (i in 1:nrow(Ih30a2)){
	row=Ih30a2[i,] # Get a row to focus on
	stat=testdat1[testdat1$Station==row$Station & testdat1$Timenew >= row$Cpstart & testdat1$Timenew <= row$Cpend,]
	if (is.na(row$MEANr)==TRUE){ # Implying this should be an HSP (even if it's the last HSP and there's a CP on the final day because they shouldn't be expected to find this)
		if (nrow(stat)==0){ # Correct rejection
			Ih30a2$detect[i]='d'
		}
		if (nrow(stat)!=0){ # False alarm
			Ih30a2$detect[i]='b'
		}	
	}
	if (is.na(row$MEANr)==FALSE){ # Implying this should be a CP
		if (nrow(stat)==0){ # Miss
			Ih30a2$detect[i]='c'
		}
		if (nrow(stat)!=0){ # Hit
			Ih30a2$detect[i]='a'
		}
	}
}

# Look at numbers of hits, false alarms, misses and correct rejections:

dim(Ih30a2[Ih30a2$detect=='a',]) # 101 hits
dim(Ih30a2[Ih30a2$detect=='b',]) # 40 false alarms
dim(Ih30a2[Ih30a2$detect=='c',]) # 262 misses
dim(Ih30a2[Ih30a2$detect=='d',]) # 470 correct rejections

nrow(Ih30a2) # 873 - This is the value for n

# Check that none of the 'false alarms' are the possible IHs in the clean data - can read this dataframe in from the following source:

load('SEW1_clean_hits_windowed.RData')

# Check if any of these 'change points' were 'detected' by Climatol-Daily:

for (i in 1:nrow(sew1clhit30)){
	row=sew1clhit30[i,] # Get a row to focus on
	stat=testdat1[testdat1$Station==row$Station & testdat1$Timenew >= row$Times & testdat1$Timenew <= row$Timee,]
	if (nrow(stat)==0){ 
		sew1clhit30$detect[i]=0 
	}
	if (nrow(stat)!=0){ # Implying this should be a CP
		sew1clhit30$detect[i]=nrow(stat)
	}
} 

sew1clhit30 # None of the 'change points' that PHA finds in the clean series are found by Climatol-Daily (because every entry in the detect column is zero)

# Get the hit rate and false alarm rate:

# Hit rate:

(nrow(Ih30a2[Ih30a2$detect=='a',]))/(nrow(Ih30a2[Ih30a2$detect=='a',])+nrow(Ih30a2[Ih30a2$detect=='c',])) # 0.278

# False alarm rate:

(nrow(Ih30a2[Ih30a2$detect=='b',]))/(nrow(Ih30a2[Ih30a2$detect=='b',])+nrow(Ih30a2[Ih30a2$detect=='d',])) # 0.078

# Frequency bias gives information about whether an algorithm is prone to over- or under-estimating the number of change points:

nrow(testdat1)/nrow(Inhomogeneitiesia) # 0.3793103

# Look at how many IHs of different addition types (method) were found:

dim(Ih30a2[Ih30a2$Method <= 0.3  & Ih30a2$detect=='a',]) # 94
dim(na.omit(Ih30a2[Ih30a2$Method <= 0.3,])) # Out of 148 - constant offset => 63.5% found

dim(Ih30a2[Ih30a2$Method > 0.3  & Ih30a2$detect=='a',]) # 7
dim(na.omit(Ih30a2[Ih30a2$Method > 0.3,])) # Out of 215 - explanatory variable perturbation  => 3.26% found

# Look at how many IHs of different sizes were found:

dim(Ih30a2[abs(Ih30a2$MEANr)>1 & Ih30a2$detect=='a',]) # 43
dim(na.omit(Ih30a2[abs(Ih30a2$MEANr)>1,])) # Out of 45 => 95.6% found

dim(Ih30a2[abs(Ih30a2$MEANr)>0.2 & abs(Ih30a2$MEANr)<=1 & Ih30a2$detect=='a',]) # 51
dim(na.omit(Ih30a2[abs(Ih30a2$MEANr)>0.2 & abs(Ih30a2$MEANr)<=1,])) # Out of 88 => 58.0% found

dim(Ih30a2[abs(Ih30a2$MEANr)<= 0.2 & Ih30a2$detect=='a',]) # 7
dim(na.omit(Ih30a2[abs(Ih30a2$MEANr)<= 0.2,])) # Out of 230 => 3.04% found

# Look at how many IHs of different types (mimicking shelter change, station relocation and urbanisation inhomogeneities) were found:

dim(Ih30a2[Ih30a2$Type < 0.34  & Ih30a2$detect=='a',]) # 39
dim(na.omit(Ih30a2[Ih30a2$Type < 0.34,])) # Out of 162 - Shelter changes => 24.1% found

dim(Ih30a2[Ih30a2$Type>=0.34 & Ih30a2$Type<=0.67 & Ih30a2$detect=='a',]) # 56
dim(na.omit(Ih30a2[Ih30a2$Type>=0.34 & Ih30a2$Type<=0.67,])) # Out of 119 station relocations => 47.1% found

dim(Ih30a2[Ih30a2$Type>0.67 & Ih30a2$detect=='a',]) # 6
dim(na.omit(Ih30a2[Ih30a2$Type>0.67,])) # Out of 82 urbanisations => 7.32% found

## Adapt the above so that multiple false alarms are counted separately even if they all fall in one HSP (and so hits are counted separately too) to test the impact of each window being counted to only have one hit or false alarm in:

for (i in 1:nrow(Ih30a2)){
	row=Ih30a2[i,] # Get a row to focus on
	stat=testdat1[testdat1$Station==row$Station & testdat1$Timenew >= row$Cpstart & testdat1$Timenew <= row$Cpend,]
	if (is.na(row$MEANr)==TRUE){ # Implying this should be an HSP (even if it's the last HSP and there's a CP on the final day)
		if (nrow(stat)==0){ # Correct rejection
			Ih30a2$detect1[i]='d'
			Ih30a2$frequency1[i]=1
		}
		if (nrow(stat)!=0){ # False alarm
			Ih30a2$detect1[i]='b'
			Ih30a2$frequency1[i]=nrow(stat)
		}	
	}
	if (is.na(row$MEANr)==FALSE){ # Implying this should be a CP
		if (nrow(stat)==0){ # Miss
			Ih30a2$detect1[i]='c'
			Ih30a2$frequency1[i]=1
		}
		if (nrow(stat)!=0){ # Hit
			Ih30a2$detect1[i]='a'
			Ih30a2$frequency1[i]=nrow(stat)
		}
	}
}

# Can now look at how many hits, misses, false alarms and correct rejections I got:

m=which(colnames(Ih30a2)=="frequency1")

nrow(Ih30a2[Ih30a2$detect1=='a',]) # 101 hits
sum(Ih30a2[Ih30a2$detect1=='a',m]) # 101 => 0 occurrence of two hits in one window
nrow(Ih30a2[Ih30a2$detect1=='b',]) # 40 false alarms
sum(Ih30a2[Ih30a2$detect1=='b',m]) # 42 => 2 occurrences of multiple false alarms
nrow(Ih30a2[Ih30a2$detect1=='c',]) # 262 misses
nrow(Ih30a2[Ih30a2$detect1=='d',]) # 470 correct rejections

# Critical success index (how does the algorithm perform in the presence or absence of inhomogeneities?):

(nrow(Ih30a2[Ih30a2$detect1=='a',]))/(nrow(Ih30a2[Ih30a2$detect1=='a',])+sum(Ih30a2[Ih30a2$detect1=='b',m])+nrow(Ih30a2[Ih30a2$detect1=='c',])) # 0.249 - if you're counting multiple FAs in a window, but not multiple hits

(sum(Ih30a2[Ih30a2$detect1=='a',m]))/(sum(Ih30a2[Ih30a2$detect1=='a',m])+sum(Ih30a2[Ih30a2$detect1=='b',m])+nrow(Ih30a2[Ih30a2$detect1=='c',])) # 0.249 - if you're counting multiple FAs in a window and multiple hits

## And look for a 90 day window:

for (i in 1:nrow(Ih90a2)){
	row=Ih90a2[i,] # Get a row to focus on
	stat=testdat1[testdat1$Station==row$Station & testdat1$Timenew >= row$Cpstart & testdat1$Timenew <= row$Cpend,]
	if (is.na(row$MEANr)==TRUE){ # Implying this should be an HSP (even if it's the last HSP and there's a CP on the final day because they shouldn't be expected to find this)
		if (nrow(stat)==0){ # Correct rejection
			Ih90a2$detect[i]='d'
		}
		if (nrow(stat)!=0){ # False alarm
			Ih90a2$detect[i]='b'
		}	
	}
	if (is.na(row$MEANr)==FALSE){ # Implying this should be a CP
		if (nrow(stat)==0){ # Miss
			Ih90a2$detect[i]='c'
		}
		if (nrow(stat)!=0){ # Hit
			Ih90a2$detect[i]='a'
		}
	}
}

# Look at numbers of hits, false alarms, misses and correct rejections:

dim(Ih90a2[Ih90a2$detect=='a',]) # 120 hits
dim(Ih90a2[Ih90a2$detect=='b',]) # 26 false alarms
dim(Ih90a2[Ih90a2$detect=='c',]) # 243 misses
dim(Ih90a2[Ih90a2$detect=='d',]) # 471 correct rejections

nrow(Ih90a2) # 860 - This is the value for n

# Check that none of the 'false alarms' are supposed IHs found in the clean data:

for (i in 1:nrow(sew1clhit90)){
	row=sew1clhit90[i,] # Get a row to focus on
	stat=testdat1[testdat1$Station==row$Station & testdat1$Timenew >= row$Times & testdat1$Timenew <= row$Timee,]
	if (nrow(stat)==0){ 
		sew1clhit90$detect[i]=0 
	}
	if (nrow(stat)!=0){ # Implying this should be a CP
		sew1clhit90$detect[i]=nrow(stat)
	}
} 

sew1clhit90 # No CPs 'found'

# Get the hit rate and false alarm rate:

# Hit rate:

(nrow(Ih90a2[Ih90a2$detect=='a',]))/(nrow(Ih90a2[Ih90a2$detect=='a',])+nrow(Ih90a2[Ih90a2$detect=='c',])) # 0.331

# False alarm rate:

(nrow(Ih90a2[Ih90a2$detect=='b',]))/(nrow(Ih90a2[Ih90a2$detect=='b',])+nrow(Ih90a2[Ih30a2$detect=='d',])) # 0.052

# Frequency bias:

nrow(testdat1)/nrow(Inhomogeneitiesia) # 0.379

# Look at how many IHs of different method were found:

dim(Ih90a2[Ih90a2$Method <= 0.3  & Ih90a2$detect=='a',]) # 101
dim(na.omit(Ih90a2[Ih90a2$Method <= 0.3,])) # Out of 148 - constant offset => 68.2% found

dim(Ih90a2[Ih90a2$Method > 0.3  & Ih90a2$detect=='a',]) # 19
dim(na.omit(Ih90a2[Ih90a2$Method > 0.3,])) # Out of 215 - explanatory variable perturbation  => 8.84% found

# Look at how many IHs of different sizes were found:

dim(Ih90a2[abs(Ih90a2$MEANr)>1 & Ih90a2$detect=='a',]) # 45
dim(na.omit(Ih90a2[abs(Ih90a2$MEANr)>1,])) # Out of 45 => 100% found

dim(Ih90a2[abs(Ih90a2$MEANr)>0.2 & abs(Ih90a2$MEANr)<=1 & Ih90a2$detect=='a',]) # 58
dim(na.omit(Ih90a2[abs(Ih90a2$MEANr)>0.2 & abs(Ih90a2$MEANr)<=1,])) # Out of 88 => 65.9% found

dim(Ih90a2[abs(Ih90a2$MEANr)<= 0.2 & Ih90a2$detect=='a',]) # 17
dim(na.omit(Ih90a2[abs(Ih90a2$MEANr)<= 0.2,])) # Out of 230 => 7.39% found

# Look at how many IHs of different type were found (not splitting by method):

dim(Ih90a2[Ih90a2$Type < 0.34  & Ih90a2$detect=='a',]) # 50
dim(na.omit(Ih90a2[Ih90a2$Type < 0.34,])) # Out of 162 - Shelter changes => 30.9% found

dim(Ih90a2[Ih90a2$Type>=0.34 & Ih90a2$Type<=0.67 & Ih90a2$detect=='a',]) # 60
dim(na.omit(Ih90a2[Ih90a2$Type>=0.34 & Ih90a2$Type<=0.67,])) # Out of 119 station relocations => 50.4% found

dim(Ih90a2[Ih90a2$Type>0.67 & Ih90a2$detect=='a',]) # 10
dim(na.omit(Ih90a2[Ih90a2$Type>0.67,])) # Out of 82 urbanisations => 12.2% found

## Adapt the above slightly so that multiple false alarms are counted separately even if they all fall in one HSP (and so hits are counted separately too):

for (i in 1:nrow(Ih90a2)){
	row=Ih90a2[i,] # Get a row to focus on
	stat=testdat1[testdat1$Station==row$Station & testdat1$Timenew >= row$Cpstart & testdat1$Timenew <= row$Cpend,]
	if (is.na(row$MEANr)==TRUE){ # Implying this should be an HSP (even if it's the last HSP and there's a CP on the final day)
		if (nrow(stat)==0){ # Correct rejection
			Ih90a2$detect1[i]='d'
			Ih90a2$frequency1[i]=1
		}
		if (nrow(stat)!=0){ # False alarm
			Ih90a2$detect1[i]='b'
			Ih90a2$frequency1[i]=nrow(stat)
		}	
	}
	if (is.na(row$MEANr)==FALSE){ # Implying this should be a CP
		if (nrow(stat)==0){ # Miss
			Ih90a2$detect1[i]='c'
			Ih90a2$frequency1[i]=1
		}
		if (nrow(stat)!=0){ # Hit
			Ih90a2$detect1[i]='a'
			Ih90a2$frequency1[i]=nrow(stat)
		}
	}
}

# Can now look at how many hits, misses, false alarms and correct rejections I got:

m=which(colnames(Ih90a2)=="frequency1")

nrow(Ih90a2[Ih90a2$detect1=='a',]) # 120 hits
sum(Ih90a2[Ih90a2$detect1=='a',m]) # 120 => 0 occurrences of two hits in one window
nrow(Ih90a2[Ih90a2$detect1=='b',]) # 26 false alarms
sum(Ih90a2[Ih90a2$detect1=='b',m]) # 27 => 1 occurrences of multiple false alarms
nrow(Ih90a2[Ih90a2$detect1=='c',]) # 243 misses
nrow(Ih90a2[Ih90a2$detect1=='d',]) # 471 correct rejections

# Critical success index:

(nrow(Ih90a2[Ih90a2$detect1=='a',]))/(nrow(Ih90a2[Ih90a2$detect1=='a',])+sum(11)+nrow(Ih90a2[Ih90a2$detect1=='c',])) # 0.321 - if you're counting multiple FAs in a window, but not multiple hits

(sum(Ih90a2[Ih90a2$detect1=='a',m]))/(sum(Ih90a2[Ih90a2$detect1=='a',m])+sum(11)+nrow(Ih90a2[Ih90a2$detect1=='c',])) # 0.321 - if you're counting multiple FAs in a window and multiple hits

# Save these dataframes:

save(Ih30a2,Ih90a2,file='Climatol_daily_sew1_IHs.RData')

## Looking at the hits and misses:

hits30=Ih30a2[Ih30a2$detect=='a',]
misses30=Ih30a2[Ih30a2$detect=='c',]

par(mfrow=c(2,1))
hist(hits30$MEANr,breaks=seq(-2.0,2.0,0.1),col="blue",main="(a)",xlab=expression(paste("Size of inhomogeneity (",degree,"C)")),ylim=c(0,90),cex=1.2,cex.main=2)
hist(misses30$MEANr,breaks=seq(-2.0,2.0,0.1),col="blue",main="(b)",xlab=expression(paste("Size of inhomogeneity (",degree,"C)")),ylim=c(0,90),cex=1.2,cex.main=2) 

hits90=Ih90a2[Ih90a2$detect=='a',]
misses90=Ih90a2[Ih90a2$detect=='c',]

par(mfrow=c(2,1))
hist(hits90$MEANr,breaks=seq(-2.0,2.0,0.1),col="blue",main="(a)",xlab=expression(paste("Size of inhomogeneity (",degree,"C)")),ylim=c(0,90),cex=1.2,cex.main=2)
hist(misses90$MEANr,breaks=seq(-2.0,2.0,0.1),col="blue",main="(b)",xlab=expression(paste("Size of inhomogeneity (",degree,"C)")),ylim=c(0,90),cex=1.2,cex.main=2) 




