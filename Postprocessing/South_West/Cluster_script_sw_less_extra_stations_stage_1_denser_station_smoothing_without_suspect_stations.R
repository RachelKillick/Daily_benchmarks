# Running different loess smooths for the whole time period for the more dense dataset:

# Load the necessary packages first:

library(mgcv)
library(akima)
library(fields)

# Load the necessary dataframes and other R things:

load('loesssurf1.RData') 
load('SWcoast1reloc_1714.RData') 
load('preds_sw_comp_11714_relocations_full_denser.RData')

# Want to look at correlations of predictions before and after deseasonalisation:

# Create a data frame to store values in

newup=SWcoast1reloc
rm(SWcoast1reloc)

newup$preds5th1=60-preds5th1

newup$preds5th1gama=preds5th1gama[,1]-preds5th1
newup$preds5th1gamb=preds5th1gamb[,1]-preds5th1

rm(preds5th1gama,preds5th1gamb)

newup=newup[newup$Station!=65,]
newup=newup[newup$Station!=143,]
newup=newup[newup$Station!=148,]
newup=newup[newup$Station!=151,]
newup=newup[newup$Station!=303,]
newup=newup[newup$Station!=690,]
newup=newup[newup$Station!=765,]
newup=newup[newup$Station!=913,]

day1170=newup[newup$Time==1,]

call1=as.matrix(cbind(day1170$Lat,day1170$Long))

# Want to be able to get the geographically closest stations in the smoothing, not just the ones R thinks are closest => use the rdist command to work out the distances East and North of the most southwesterly point of the region (-123,32)

lon=rdist.earth(cbind(call1[,2],rep(32,444)),cbind(-123,32),miles=FALSE)
lat=rdist.earth(cbind(rep(-123,444),call1[,1]),cbind(-123,32),miles=FALSE)

call1=cbind(lon,lat)

lsmodel35a=data.frame(matrix(ncol=2,nrow=6810960)) 
lsmodel35b=data.frame(matrix(ncol=2,nrow=6810960)) 

ls35=35/444

# Look at creating the loess smoothed versions of the errors:

for (j in 1:15340){
	day=newup[newup$Time==j,]
	namemodel35a=loess.surf1(day$preds5th1gama,call1,degree=2,span=ls35) 
	namemodel35b=loess.surf1(day$preds5th1gamb,call1,degree=2,span=ls35)  

	j1=444*(j-1)+1
	j2=444*j
	lsmodel35a[j1:j2,1]=seq(1,444)
	lsmodel35a[j1:j2,2]=namemodel35a
	lsmodel35b[j1:j2,1]=seq(1,444)
	lsmodel35b[j1:j2,2]=namemodel35b

}

lsmodel35aa=lsmodel35a[with(lsmodel35a, order(lsmodel35a[,1])), ]
lsmodel35ca=lsmodel35aa[,2]
lsmodel35ab=lsmodel35b[with(lsmodel35b, order(lsmodel35b[,1])), ]
lsmodel35cb=lsmodel35ab[,2]

save(lsmodel35ca,lsmodel35cb,file='loessmodel_sw_comp_11814_relocations_full_denser_35.RData')

newup$lsmodel35a=60-(lsmodel35aa[,2]+(60-newup$preds5th1))
newup$lsmodel35b=60-(lsmodel35ab[,2]+(60-newup$preds5th1))

save(newup,file='newup_sw_comp_10614_relocations_full_denser_35.RData')

# Creating the means and deasonalised versions of the predictions:

menmodel35a=as.data.frame(matrix(nrow=366,ncol=444))
menmodel35b=as.data.frame(matrix(nrow=366,ncol=444))

newup$Station1=sort(rep(1:444,15340))

for (i in 1:444){
	stat=newup[newup$Station1==i,]
	statn29=stat[stat$Dyear!=59.5,]
	stat29=stat[stat$Dyear==59.5,]
	statar35a=t(array(statn29$lsmodel35a,dim=c(365,42)))
	menmodel35a[1:59,i]=apply(statar35a[,1:59],2,mean)
	menmodel35a[61:366,i]=apply(statar35a[,60:365],2,mean)
	menmodel35a[60,i]=mean(stat29$lsmodel35a)
	statar35b=t(array(statn29$lsmodel35b,dim=c(365,42)))
	menmodel35b[1:59,i]=apply(statar35b[,1:59],2,mean)
	menmodel35b[61:366,i]=apply(statar35b[,60:365],2,mean)
	menmodel35b[60,i]=mean(stat29$lsmodel35b)

}
 
save(menmodel35a,menmodel35b,file='mean_sw_comp_61014_relocations_denser_full_35.RData')

menmodel351a=rbind(menmodel35a[-60,],menmodel35a[-60,],menmodel35a,menmodel35a[-60,],menmodel35a[-60,],menmodel35a[-60,],menmodel35a,menmodel35a[-60,],menmodel35a[-60,],menmodel35a[-60,],menmodel35a,menmodel35a[-60,],menmodel35a[-60,],menmodel35a[-60,],menmodel35a,menmodel35a[-60,],menmodel35a[-60,],menmodel35a[-60,],menmodel35a,menmodel35a[-60,],menmodel35a[-60,],menmodel35a[-60,],menmodel35a,menmodel35a[-60,],menmodel35a[-60,],menmodel35a[-60,],menmodel35a,menmodel35a[-60,],menmodel35a[-60,],menmodel35a[-60,],menmodel35a,menmodel35a[-60,],menmodel35a[-60,],menmodel35a[-60,],menmodel35a,menmodel35a[-60,],menmodel35a[-60,],menmodel35a[-60,],menmodel35a,menmodel35a[-60,],menmodel35a[-60,],menmodel35a[-60,])
rm(menmodel35a)

menmodel351b=rbind(menmodel35b[-60,],menmodel35b[-60,],menmodel35b,menmodel35b[-60,],menmodel35b[-60,],menmodel35b[-60,],menmodel35b,menmodel35b[-60,],menmodel35b[-60,],menmodel35b[-60,],menmodel35b,menmodel35b[-60,],menmodel35b[-60,],menmodel35b[-60,],menmodel35b,menmodel35b[-60,],menmodel35b[-60,],menmodel35b[-60,],menmodel35b,menmodel35b[-60,],menmodel35b[-60,],menmodel35b[-60,],menmodel35b,menmodel35b[-60,],menmodel35b[-60,],menmodel35b[-60,],menmodel35b,menmodel35b[-60,],menmodel35b[-60,],menmodel35b[-60,],menmodel35b,menmodel35b[-60,],menmodel35b[-60,],menmodel35b[-60,],menmodel35b,menmodel35b[-60,],menmodel35b[-60,],menmodel35b[-60,],menmodel35b,menmodel35b[-60,],menmodel35b[-60,],menmodel35b[-60,])
rm(menmodel35b)

save(menmodel351a,menmodel351b,file='meantab_sw_comp_61014_relcoations_denser_full_35.RData')

# Now is it easier to put the predicted series in table form or the measns in column form (I think the former - as long as the subtraction still works then (it does as long as you loop over the columns instead of trying to do it all in one go I think...)

# Create data frames to store the predictions in in a column by column format

model35a=as.data.frame(matrix(nrow=15340,ncol=444))
model35b=as.data.frame(matrix(nrow=15340,ncol=444))

# Fill the data frames with predictions in a column by column format for each station

for (i in 1:444){
	j1=(i-1)*15340+1
	j2=i*15340
	new1=newup[newup$Station1==i,]
	model35a[,i]=new1$lsmodel35a
	model35b[,i]=new1$lsmodel35b
}

# Create data frames for the deseasonalised values - one column for each station:

deseason35a=as.data.frame(matrix(nrow=15340,ncol=444))
deseason35b=as.data.frame(matrix(nrow=15340,ncol=444))

# Fill the data frames by subtracting the mean for each station from the prediction for each station on a column by column basis:

for (i in 1:444){
	deseason35a[,i]=model35a[,i]-menmodel351a[,i]
	deseason35b[,i]=model35b[,i]-menmodel351b[,i]
}

save(deseason35a,deseason35b,file='deseasontab_sw_comp_61014_relocations_denser_full_35.RData')


