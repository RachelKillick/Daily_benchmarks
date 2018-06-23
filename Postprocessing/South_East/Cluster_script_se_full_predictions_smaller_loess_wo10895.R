# Hopefully verging on my final model for SE

# Load the necessary packages first:

library(mgcv)
library(akima)
library(fields)

# Load the necessary dataframes and other R things:

load('loesssurf1.RData') 
load('SEcoast1relocor_1714.RData') 
load('preds_se_11714_smaller_full.RData')

# Want to look at correlations of predictions before and after deseasonalisation:

# Create a data frame to store values in

newup=SEcoast1relocor
rm(SEcoast1relocor) # Because I don't want a MASSIVE dataframe in the work space twice!

newup$pred5th1=60-pred5th1

newup$pred5th1gam=pred5th1gam[,1]-pred5th1

rm(pred5th1gam)

newup=newup[newup$Station!=95,] # This is a REALLY hard call because it probably could be left in for 45 stats (which is what I'm intending on using) but would need to be removed for 40 stats... - I think my conclusion is that it should go though
newup=newup[newup$Station!=108,]

day1170=newup[newup$Time==1,]

call1=as.matrix(cbind(day1170$Lat,day1170$Long))

# Want to be able to get the geographically closest stations in the smoothing, not just the ones R thinks are closest => use the rdist command to work out the distances East and North of the most southwesterly point of the region (-90.1,25) (this has been altered slightly for the more dense network)

lon=rdist.earth(cbind(call1[,2],rep(25,306)),cbind(-90.1,25),miles=FALSE)
lat=rdist.earth(cbind(rep(-90.1,306),call1[,1]),cbind(-90.1,25),miles=FALSE)

call1=cbind(lon,lat) 

lsmodel40=data.frame(matrix(ncol=2,nrow=4694040)) 
lsmodel45=data.frame(matrix(ncol=2,nrow=4694040)) 

ls40=40/306
ls45=45/306 # Of course in reducing the number of stats there are I am INCREASING the proportion of stats that I'm smoothing wrt... this might change things - warg! Though actually I think it's OK because it's the NUMBER of stations I'm interested in (and the proportion which is what the loess is fed won't change THAT much... so I think it should be OK...)

# Look at creating the loess smoothed versions of the errors:

for (j in 1:15340){
	day=newup[newup$Time==j,]
	namemodel40=loess.surf1(day$pred5th1gam,call1,degree=2,span=ls40)
	namemodel45=loess.surf1(day$pred5th1gam,call1,degree=2,span=ls45)

	j1=306*(j-1)+1
	j2=306*j
	lsmodel40[j1:j2,1]=seq(1,306)
	lsmodel40[j1:j2,2]=namemodel40	
	lsmodel45[j1:j2,1]=seq(1,306)
	lsmodel45[j1:j2,2]=namemodel45
}

lsmodel40a=lsmodel40[with(lsmodel40, order(lsmodel40[,1])), ]
lsmodel40c=lsmodel40a[,2]
lsmodel45a=lsmodel45[with(lsmodel45, order(lsmodel45[,1])), ]
lsmodel45c=lsmodel45a[,2]

save(lsmodel40c,lsmodel45c,file='loessmodel_se_comp_201014_relocations_full_smaller_loess_wo95108.RData')

newup$lsmodel40=60-(lsmodel40c+(60-newup$pred5th1))
newup$lsmodel45=60-(lsmodel45c+(60-newup$pred5th1))

save(newup,file='newup_se_comp_201014_relocations_full_smaller_loess_wo59108.RData')

# Work out the means and deseasonalised series:

menmodel40=as.data.frame(matrix(nrow=366,ncol=306))
menmodel45=as.data.frame(matrix(nrow=366,ncol=306))

newup$Station=sort(rep(1:306,15340))

for (i in 1:306){
	stat=newup[newup$Station==i,]
	statn29=stat[stat$Dyear!=59.5,]
	stat29=stat[stat$Dyear==59.5,]
	statar45=t(array(statn29$lsmodel45,dim=c(365,42)))
	statar40=t(array(statn29$lsmodel40,dim=c(365,42)))
	menmodel45[1:59,i]=apply(statar45[,1:59],2,mean)
	menmodel40[1:59,i]=apply(statar40[,1:59],2,mean)
	menmodel45[61:366,i]=apply(statar45[,60:365],2,mean)
	menmodel40[61:366,i]=apply(statar40[,60:365],2,mean)
	menmodel45[60,i]=mean(stat29$lsmodel45)
	menmodel40[60,i]=mean(stat29$lsmodel40)
}
 
save(menmodel40,menmodel45,file='mean_se_comp_201014_relocations_smaller_full_wo95108.RData')

menmodel401=rbind(menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,],menmodel40,menmodel40[-60,],menmodel40[-60,],menmodel40[-60,])
rm(menmodel40)
menmodel451=rbind(menmodel45[-60,],menmodel45[-60,],menmodel45,menmodel45[-60,],menmodel45[-60,],menmodel45[-60,],menmodel45,menmodel45[-60,],menmodel45[-60,],menmodel45[-60,],menmodel45,menmodel45[-60,],menmodel45[-60,],menmodel45[-60,],menmodel45,menmodel45[-60,],menmodel45[-60,],menmodel45[-60,],menmodel45,menmodel45[-60,],menmodel45[-60,],menmodel45[-60,],menmodel45,menmodel45[-60,],menmodel45[-60,],menmodel45[-60,],menmodel45,menmodel45[-60,],menmodel45[-60,],menmodel45[-60,],menmodel45,menmodel45[-60,],menmodel45[-60,],menmodel45[-60,],menmodel45,menmodel45[-60,],menmodel45[-60,],menmodel45[-60,],menmodel45,menmodel45[-60,],menmodel45[-60,],menmodel45[-60,])
rm(menmodel45)

save(menmodel401,menmodel451,file='meantab_se_comp_201014_relcoations_smaller_full_wo95108.RData')

# Now is it easier to put the predicted series in table form or the measns in column form (I think the former - as long as the subtraction still works then (it does as long as you loop over the columns instead of trying to do it all in one go I think...)

# Create data frames to store the predictions in in a column by column format

model40=as.data.frame(matrix(nrow=15340,ncol=306))
model45=as.data.frame(matrix(nrow=15340,ncol=306))

# Fill the data frames with predictions in a column by column format for each station

for (i in 1:306){
	j1=(i-1)*15340+1
	j2=i*15340
	new1=newup[newup$Station==i,]
	model40[,i]=new1$lsmodel40
	model45[,i]=new1$lsmodel45
}

# Create data frames for the deseasonalised values - one column for each station:

deseason40=as.data.frame(matrix(nrow=15340,ncol=306))
deseason45=as.data.frame(matrix(nrow=15340,ncol=306))

# Fill the data frames by subtracting the mean for each station from the prediction for each station on a column by column basis:

for (i in 1:306){
	deseason40[,i]=model40[,i]-menmodel401[,i]
	deseason45[,i]=model45[,i]-menmodel451[,i]
}

save(deseason40,deseason45,file='deseasontab_se_comp_201014_relocations_smaller_full_wo95108.RData')




