# This document contains the calculations and comparisons for deciding on the level of spatial and temporal smoothing in Wyoming scenario 4.
# If you wish to run this code to check results from Killick et al., please contact the authors for all the required data. 

# The things being considered here are:
# lsmodel25 and lsmodel25 corrupted because I want to be able to compare with what I've already done
# The observations
# 15w9, 18w9
# 15w9n, 18w9n
# 15w5n though probably already ruled out
# 20w3 though probably already ruled out
# 15w15n and 18w15n though probaby already ruled out

# First read in all my dataframes (please contact the authors for these data):

# This follows on from the Deciding_on_smoothing_for_weighted_WY_release_smaller_301014.R document and the 'An_alternative_approach.R document'

# Right - now repeat analysis from other document here:

load('/scratch/rw307/Reading/Scripts/Final_versions/Wyoming_temporal/newup_wyoming_temoral_investigation_101114.RData') # From the other document

lsmodel20w3=newup$lsmodel20w3
lsmodel18w5n=newup$lsmodel18w5n
lsmodel15w5n=newup$lsmodel15w5n
TMEAN=newupsor$TMEAN

load('/scratch/rw307/Reading/Scripts/Wyoming_new/ClusterScripts/ModelOutputs/SIngle_relocation_option/Re-runs/Full_time_period/Smaller/newup_wy_comp_121114_relocations_full_smaller_temporal_weighted_averaging_different.RData')

lsmodel25=newup$lsmodel25
lsmodel18w9=newup$lsmodel18w9
lsmodel15w9=newup$lsmodel15w9

load('/scratch/rw307/Reading/Scripts/Wyoming_new/ClusterScripts/ModelOutputs/SIngle_relocation_option/Re-runs/Full_time_period/Smaller/newup_wy_comp_21214_relocations_full_smaller_temporal_weighted_averaging_different_again.RData')

lsmodel15w9n=newup$lsmodel15w9n
lsmodel18w9n=newup$lsmodel18w9n

load('/scratch/rw307/Reading/Scripts/Wyoming_new/ClusterScripts/ModelOutputs/SIngle_relocation_option/Re-runs/Full_time_period/Smaller/newup_wy_comp_21214_relocations_full_smaller_temporal_weighted_averaging_different_again_15.RData')

lsmodel18w15n=newup$lsmodel18w15n
lsmodel15w15n=newup$lsmodel15w15n

# Also want to consider the corrupted versions that I have already run 20w3, 18w9 and 15w9 (and of course the corrupted release version):

load('/scratch/rw307/Reading/Scripts/Final_versions/Wyoming_temporal/Wyoming_smaller_inhomogeneities_31214_propogate_backwards_table.RData')

lsmodel18w9c=Predictsetf2$Inhomogeneous

load('/scratch/rw307/Reading/Scripts/Final_versions/Wyoming_temporal/Wyoming_smaller_inhomogeneities_31214_propogate_backwards_table_15w9.RData')

lsmodel15w9c=Predictsetf2$Inhomogeneous

load('/scratch/rw307/Reading/Scripts/Final_versions/Wyoming_temporal/Wyoming_smaller_inhomogeneities_31214_propogate_backwards_table_20w3.RData') 

lsmodel20w3c=Predictsetf2$Inhomogeneous

load('/scratch/rw307/Reading/Scripts/Final_versions/Wyoming_first_release/Wyoming_world1_corrupted_release.RData')

lsmodel25c=Predictsetf1$Inhomogeneous

load('/scratch/rw307/Reading/Scripts/Final_versions/Wyoming_temporal/Wyoming_smaller_inhomogeneities_31214_propogate_backwards_table_15w5n.RData')

lsmodel15w5nc=Predictsetf1$Inhomogeneous

load('/scratch/rw307/Reading/Scripts/Final_versions/Wyoming_temporal/Wyoming_smaller_inhomogeneities_31214_propogate_backwards_table_15w9n.RData')

lsmodel15w9nc=Predictsetf1$Inhomogeneous

load('/scratch/rw307/Reading/Scripts/Final_versions/Wyoming_temporal/Wyoming_smaller_inhomogeneities_31214_propogate_backwards_table_18w9n.RData')

lsmodel18w9nc=Predictsetf1$Inhomogeneous

load('/scratch/rw307/Reading/Scripts/Final_versions/Wyoming_temporal/Wyoming_smaller_inhomogeneities_31214_propogate_backwards_table_15w15n.RData')

lsmodel15w15nc=Predictsetf1$Inhomogeneous

load('/scratch/rw307/Reading/Scripts/Final_versions/Wyoming_temporal/Wyoming_smaller_inhomogeneities_31214_propogate_backwards_table_18w15n.RData')

lsmodel18w15nc=Predictsetf1$Inhomogeneous

load('/scratch/rw307/Reading/Scripts/Final_versions/Wyoming_temporal/Wyoming_smaller_inhomogeneities_31214_propogate_backwards_table_18w5n.RData')

lsmodel18w5nc=Predictsetf1$Inhomogeneous

# newup=newup[,-c(19:26)] Don't run this command again or I'll end up getting rid of things that I do still want

newup$lsmodel18w5n=lsmodel18w5n
newup$lsmodel15w5n=lsmodel15w5n
newup$lsmodel20w3=lsmodel20w3
newup$lsmodel18w9=lsmodel18w9
newup$lsmodel15w9=lsmodel15w9
newup$lsmodel15w9n=lsmodel15w9n
newup$lsmodel18w9n=lsmodel18w9n
newup$lsmodel18w15n=lsmodel18w15n
newup$lsmodel15w15n=lsmodel15w15n
newup$lsmodel25=lsmodel25 

newupsor=newup[newup$Station_Realisation==6,]

newupsor$lsmodel25c=lsmodel25c
newupsor$lsmodel20w3c=lsmodel20w3c
newupsor$lsmodel18w9c=lsmodel18w9c
newupsor$lsmodel15w9c=lsmodel15w9c
newupsor$lsmodel15w5nc=lsmodel15w5nc
newupsor$lsmodel15w9nc=lsmodel15w9nc
newupsor$lsmodel18w9nc=lsmodel18w9nc
newupsor$lsmodel15w15nc=lsmodel15w15nc
newupsor$lsmodel18w15nc=lsmodel18w15nc
newupsor$lsmodel18w5nc=lsmodel18w5nc
newupsor$TMEAN=TMEAN

# Now make the corrupted data missing to the same level as the original data:

newupsor[is.na(newupsor$TMEAN),c(36:44)] <- NA

# Before doing anything else run these clean versions through the PHA as there is no point in doing anymore if they show up loads of false detections (I already know that the others are OK):

load('/scratch/rw307/Reading/Scripts/Wyoming_new/wyupdatefeb29gam.RData')

stat1old=wyupdatefeb29gam[wyupdatefeb29gam$Station==1,]

newupsor$Year=stat1old$Year
newupsor$Month=stat1old$Month

Yearrec=sort(rep(1970:2011,12))
Monthrec=rep(1:12,42)

# Averaging the data to the monthly level

wymonthlydor=as.data.frame(matrix(nrow=37800,ncol=8))
names(wymonthlydor)=c('Station','Year','Month','eighteenw5n','fifteenw9n','eighteenw9n','fifteenw15n','eighteenw15n')
wymonthlydor$Station=sort(rep(1:75,504))
wymonthlydor$Year=Yearrec
wymonthlydor$Month=Monthrec

for (i in 1:75){
	stat=newupsor[newupsor$Station==i,]
	for (j in 1970:2011){
		year=stat[stat$Year==j,]
			for (k in 1:12){
				month=year[year$Month==k,]
				wymonthlydor[((i-1)*504+(j-1970)*12+k),4]=mean(month$lsmodel18w5n,na.rm=TRUE)
				wymonthlydor[((i-1)*504+(j-1970)*12+k),5]=mean(month$lsmodel15w9n,na.rm=TRUE)
				wymonthlydor[((i-1)*504+(j-1970)*12+k),6]=mean(month$lsmodel18w9n,na.rm=TRUE)
				wymonthlydor[((i-1)*504+(j-1970)*12+k),7]=mean(month$lsmodel15w15n,na.rm=TRUE)
				wymonthlydor[((i-1)*504+(j-1970)*12+k),8]=mean(month$lsmodel18w15n,na.rm=TRUE)
			}
	}
}

codes=read.table('/scratch/rw307/Reading/Scripts/Wyoming_new/Station_codes_created_for_wy_2714.txt')

library(gdata)

for (i in 1:75){
	statrec18w5n=as.data.frame(matrix(nrow=42,ncol=14),colnames=NULL)
#	statrec15w9n=as.data.frame(matrix(nrow=42,ncol=14),colnames=NULL)
#	statrec18w9n=as.data.frame(matrix(nrow=42,ncol=14),colnames=NULL)
#	statrec15w15n=as.data.frame(matrix(nrow=42,ncol=14),colnames=NULL)
#	statrec18w15n=as.data.frame(matrix(nrow=42,ncol=14),colnames=NULL)
	stat=wymonthlydor[wymonthlydor$Station==i,]
	for (j in 1970:2011){
		statrec18w5n[(j-1969),3:14]=t(round(stat[stat$Year==j,4],digits=2)*100)
#		statrec15w9n[(j-1969),3:14]=t(round(stat[stat$Year==j,5],digits=2)*100)
#		statrec18w9n[(j-1969),3:14]=t(round(stat[stat$Year==j,6],digits=2)*100)
#		statrec15w15n[(j-1969),3:14]=t(round(stat[stat$Year==j,7],digits=2)*100)
#		statrec18w15n[(j-1969),3:14]=t(round(stat[stat$Year==j,8],digits=2)*100)
	}
	statrec18w5n[,2]=1970:2011
	statrec18w5n[,1]=codes[i,]
#	statrec15w9n[,2]=1970:2011
#	statrec15w9n[,1]=codes[i,]
#	statrec18w9n[,2]=1970:2011
#	statrec18w9n[,1]=codes[i,]
#	statrec15w15n[,2]=1970:2011
#	statrec15w15n[,1]=codes[i,]
#	statrec18w15n[,2]=1970:2011
#	statrec18w15n[,1]=codes[i,]
	write.fwf(statrec18w5n,width=c(11,4,5,8,8,8,8,8,8,8,8,8,8,8),file=paste(codes[i,],'.raw.tavg',sep=""),colnames=FALSE)
#	write.fwf(statrec15w9n,width=c(11,4,5,8,8,8,8,8,8,8,8,8,8,8),file=paste(codes[i,],'.raw.tavg',sep=""),colnames=FALSE)
#	write.fwf(statrec18w9n,width=c(11,4,5,8,8,8,8,8,8,8,8,8,8,8),file=paste(codes[i,],'.raw.tavg',sep=""),colnames=FALSE)
#	write.fwf(statrec15w15n,width=c(11,4,5,8,8,8,8,8,8,8,8,8,8,8),file=paste(codes[i,],'.raw.tavg',sep=""),colnames=FALSE)
#	write.fwf(statrec18w15n,width=c(11,4,5,8,8,8,8,8,8,8,8,8,8,8),file=paste(codes[i,],'.raw.tavg',sep=""),colnames=FALSE)
} # Yay!!!! this is exactly what I want I think

# This is when you look at the originals and relocation options merged into one:

# WY18w15n - 3 IHs that are detected where the value is bigger than the error bounds on it
# WY18w9n - 2 IHs that are detected where the value is bigger than the error bounds on it
# WY18w5n - 3 IHs that are detected where the value is bigger than the error bounds on it - but I think perhaps there were less errors found in general - not just less that the PHA was sure about 
# WY15w15n - 7 IHs that are detected where the value is bigger than the error bounds on it
# WY15wn - 5 IHs that are detected where the value is bigger than the error bounds on it

# This is when you look at just the origianl station options (really I probably should look at the relocation options too, but time is of the essence, so I think I'll only do that for whichever smooth I actually use):

# WY15w5n - 10 IHs that are detected where the value is bigger than the error bounds on it out of 17 IHs detected
# WY15w9 - 8 IHs that are detected where the value is bigger than the error bounds on it out of 18 IHs detected
# WY18w9 - 14 IHs that are detected where the value is bigger than the error bounds on it out of 22 IHs detected
# WY20w3 - 9 IHs that are detected where the value is bigger than the error bounds on it out of 15 IHs detected
# WY18w9n - 13 IHs that are detected where the value is bigger than the error bounds on it out of 23 IHs detected
# WY18w5n - 9 IHs that are detected where the value is bigger than the error bounds on it out of 15 IHs detected
# WY15w9n - 7 IHs that are detected where the value is bigger than the error bounds on it out of 9 IHs detected
# WY18w15n - 8 IHs that are detected where the value is bigger than the error bounds on it out of 16 IHs detected
# WY15w15n - 5 IHs that are detected where the value is bigger than the error bounds on it out of 10 IHs detected

# Right - none of these can be ruled out on the grounds of being terrible when run through the PHA (although these are of course only the original stations and not the relocation options) - though 18w9 and 18w9n now seem to have the most IHs detected

# Check that I haven't got any values that are too extreme:

plot(density(na.omit(newupsor$TMEAN),bw=0.6),lwd=3,main="Comparing observed and predicted densities in Wyoming",xlim=c(-60,50),ylim=c(0,0.035))
lines(density(newup$lsmodel25,bw=0.6),col="red",lwd=2) 
lines(density(na.omit(newupsor$lsmodel25),bw=0.6),col="red",lwd=2,lty=2) 
lines(density(newup$lsmodel20w3,bw=0.6),col="dark orange",lwd=2) 
lines(density(na.omit(newupsor$lsmodel20w3c),bw=0.6),col="dark orange",lwd=2,lty=2) 
lines(density(newup$lsmodel18w5n,bw=0.6),col="orange",lwd=2) 
lines(density(na.omit(newupsor$lsmodel18w5nc),bw=0.6),col="orange",lwd=2,lty=2) 
lines(density(newup$lsmodel18w9,bw=0.6),col="dark green",lwd=2) 
lines(density(na.omit(newupsor$lsmodel18w9c),bw=0.6),col="dark green",lwd=2,lty=2) 
lines(density(newup$lsmodel18w9n,bw=0.6),col="blue",lwd=2) 
lines(density(na.omit(newupsor$lsmodel18w9nc),bw=0.6),col="blue",lwd=2,lty=2) 
lines(density(newup$lsmodel18w15n,bw=0.6),col="dark blue",lwd=2)
lines(density(na.omit(newupsor$lsmodel18w15nc),bw=0.6),col="dark blue",lwd=2,lty=2)
lines(density(newup$lsmodel15w5n,bw=0.6),col="purple",lwd=2) 
lines(density(na.omit(newupsor$lsmodel15w5nc),bw=0.6),col="purple",lwd=2,lty=2) 
lines(density(newup$lsmodel15w9,bw=0.6),col="pink",lwd=2) 
lines(density(na.omit(newupsor$lsmodel15w9c),bw=0.6),col="pink",lwd=2,lty=2) 
lines(density(newup$lsmodel15w9n,bw=0.6),col="magenta",lwd=2) 
lines(density(na.omit(newupsor$lsmodel15w9nc),bw=0.6),col="magenta",lwd=2,lty=2)
lines(density(newup$lsmodel15w15n,bw=0.6),col="brown",lwd=2)
lines(density(na.omit(newupsor$lsmodel15w5nc),bw=0.6),col="brown",lwd=2,lty=2) # saved as wyf_fig1

plot(density(na.omit(newupsor$TMEAN),bw=0.6),lwd=3,main="Comparing observed and predicted densities in Wyoming",xlim=c(-60,50),ylim=c(0,0.035))
lines(density(newup$lsmodel18w9,bw=0.6),col="dark green",lwd=2) 
lines(density(na.omit(newupsor$lsmodel18w9c),bw=0.6),col="dark green",lwd=2,lty=2) 
lines(density(newup$lsmodel15w9,bw=0.6),col="pink",lwd=2) 
lines(density(na.omit(newupsor$lsmodel15w9c),bw=0.6),col="pink",lwd=2,lty=2) # saved as wyf_fig1b

# Quite hard to tell from the plot => look at actual summary statistics: (interested in medians and extremes mostly I think)

summary(newup$lsmodel25) # Min -43.26, LQ -1.70, Med 6.11, Men 6.04, UQ 14.68, Max 32.42 # 8 values missed at upper end and 7 values are too extreme at the lower end
summary(newup$lsmodel20w3) # Min - 44.06, LQ -1.74, Med 6.07, Men 6.04, UQ 14.64, Max 33.40 # 3 values missed at upper end and 5 are too extreme at lower end
summary(newup$lsmodel18w5n) # Min -45.43, LQ -1.729, Med 6.07, Men 6.04, UQ 14.64, Max 33.39 # 3 values missed at upper end and 2 values are too extreme at the lower end
summary(newup$lsmodel18w9) # Min -43.49, LQ -1.73, Med 6.07, Men 6.04, UQ 14.64, Max 33.2 # 3 values would be lost from the upper end and only 2 values are too extreme at the lower end
summary(newup$lsmodel18w9n) # Min -43.37, LQ -1.726, Med 6.07, Men 6.04, UQ 14.65, Max 32.62 # 6 values would be lost from the upper end and 2 values are too extreme at the lower end
summary(newup$lsmodel18w15n) # Min -42.15, LQ -1.716, Med 6.06, Men 6.04, UQ, 14.65, Max 32 # 11 values would be lost from the upper end and 3 values would be too extreme at the lower end
summary(newup$lsmodel15w5n) # Min -45.68, LQ -1.75, Med 6.08, Men 6.04, UQ 14.64, Max 36.46 # 5 values too extreme at upper end and 3 values too extreme at lower end
summary(newup$lsmodel15w9) # Min -43.51, LQ -1.75, Med 6.08, Men 6.04, UQ 14.64, Max 38.48 # 4 values too extreme at upper end and 2 values too extreme at lower end
summary(newup$lsmodel15w9n) # Min -43.44, LQ -1.74, Med 6.07, Men 6.04, UQ 14.64, Max 36.97 # 1 value too extreme at the upper end and 2 values too extreme at the lower end 
summary(newup$lsmodel15w15n) # Min -42.44, LQ -1.73, Med 6.06, Men 6.04, UQ 14.64, Max 35.13 # 1 value lost at the upper end and 3 values too extreme at the lower end 

# By comparing these values with the ones calculated from my dataframe with no missing data you can see the impact that having missing data has - and it is quite noticeable - it changes the average temp by around point 1 degrees in places

summary(newupsor$TMEAN) # Min -39.20, LQ -1.40, Med 6.40, Men 6.20, UQ 15, Max 35.25
summary(newupsor$lsmodel25c) # Min -43.15, LQ -1.50, Med 6.35, Men 6.26, UQ 14.91, Max 31.94 # 13 values missed at the upper end and 5 values are too extreme at the lower end 
summary(newupsor$lsmodel20w3c) # Min - 41.28, LQ -1.58, Med 6.28, Men 6.22, UQ 14.84, Max 32.25 # 8 values missed at upper end and 3 are too extreme at lower end - Corruption seems to be making things warmer on average
summary(newupsor$lsmodel18w5nc) # Min -40.53, Med 6.30, Max 33.39 # 3 vales lost at the upper end and 1 value too extreme at the lower end 
summary(newupsor$lsmodel18w9c) # Min -40.6, LQ -1.54, Med 6.29, Men 6.25, UQ 14.87 Max 32.84 # 2 values would be lost from the upper end and 2 values are too extreme at the lower end
summary(newupsor$lsmodel18w9nc) # Min -40.28, Med 6.29, Max 32.47 # 8 values missed at the upper end and 2 values that are too extreme at the lower end 
summary(newupsor$lsmodel18w15nc) # Min -41.19, Med 6.29, Max 32.42 # 8 values missed at the upper end and 2 values that are too extreme at the lower end 
summary(newupsor$lsmodel15w5nc) # Min -40.46, LQ -1.57, Med 6.30, Men 6.25, UQ 14.86, Max 36.24 # 5 values too extreme at upper end (though clearly not too much too extreme) and 2 values too extreme at lower end (though again, not too too extreme)
summary(newupsor$lsmodel15w9c) # Min -40.64, LQ -1.56, Med 6.29, Men 6.25, UQ 14.86, Max 38.48 # 4 values too extreme at upper end and 2 values too extreme at lower end
summary(newupsor$lsmodel15w9nc) # Min -40.24, Med 6.30, Max 36.97 # 1 value too extreme at the upper end and 2 values too extreme at the lower end => Maybe this would be a viable candidate
summary(newupsor$lsmodel15w15nc) # Min -41.11, Med 6.27, Max 35.13 # 1 value missed at the upper end and 3 values too extreme at the lower end 

# Now work out the inter-station correlations (both with and without using first difference series):

truetf=as.data.frame(matrix(nrow=15340,ncol=75))
model525=as.data.frame(matrix(nrow=15340,ncol=75))
model525c=as.data.frame(matrix(nrow=15340,ncol=75))
model520w3=as.data.frame(matrix(nrow=15340,ncol=75))
model520w3c=as.data.frame(matrix(nrow=15340,ncol=75))
model518w5n=as.data.frame(matrix(nrow=15340,ncol=75))
model518w5nc=as.data.frame(matrix(nrow=15340,ncol=75))
model518w9=as.data.frame(matrix(nrow=15340,ncol=75))
model518w9c=as.data.frame(matrix(nrow=15340,ncol=75))
model518w9n=as.data.frame(matrix(nrow=15340,ncol=75))
model518w9nc=as.data.frame(matrix(nrow=15340,ncol=75))
model518w15n=as.data.frame(matrix(nrow=15340,ncol=75))
model518w15nc=as.data.frame(matrix(nrow=15340,ncol=75))
model515w5n=as.data.frame(matrix(nrow=15340,ncol=75))
model515w5nc=as.data.frame(matrix(nrow=15340,ncol=75))
model515w9=as.data.frame(matrix(nrow=15340,ncol=75))
model515w9c=as.data.frame(matrix(nrow=15340,ncol=75))
model515w9n=as.data.frame(matrix(nrow=15340,ncol=75))
model515w9nc=as.data.frame(matrix(nrow=15340,ncol=75))
model515w15n=as.data.frame(matrix(nrow=15340,ncol=75))
model515w15nc=as.data.frame(matrix(nrow=15340,ncol=75))

for (i in 1:75){
	j1=(i-1)*15340+1
	j2=i*15340
	new1=newupsor[newupsor$Station==i,]
	truetf[,i]=new1$TMEAN
	model525[,i]=new1$lsmodel25
	model525c[,i]=new1$lsmodel25c
	model520w3[,i]=new1$lsmodel20w3
	model520w3c[,i]=new1$lsmodel20w3c
	model518w5n[,i]=new1$lsmodel18w5n
	model518w5nc[,i]=new1$lsmodel18w5nc
	model518w9[,i]=new1$lsmodel18w9
	model518w9c[,i]=new1$lsmodel18w9c
	model518w9n[,i]=new1$lsmodel18w9n
	model518w9nc[,i]=new1$lsmodel18w9nc
	model518w15n[,i]=new1$lsmodel18w15n
	model518w15nc[,i]=new1$lsmodel18w15nc
	model515w5n[,i]=new1$lsmodel15w5n
	model515w5nc[,i]=new1$lsmodel15w5nc
	model515w9[,i]=new1$lsmodel15w9
	model515w9c[,i]=new1$lsmodel15w9c
	model515w9n[,i]=new1$lsmodel15w9n
	model515w9nc[,i]=new1$lsmodel15w9nc
	model515w15n[,i]=new1$lsmodel15w15n
	model515w15nc[,i]=new1$lsmodel15w15nc
}

difftrue=apply(truetf,2,diff,d=1)
diff25=apply(model525,2,diff,d=1)
diff25c=apply(model525c,2,diff,d=1)
diff20w3=apply(model520w3,2,diff,d=1)
diff20w3c=apply(model520w3c,2,diff,d=1)
diff18w5n=apply(model518w5n,2,diff,d=1)
diff18w5nc=apply(model518w5nc,2,diff,d=1)
diff18w9=apply(model518w9,2,diff,d=1)
diff18w9c=apply(model518w9c,2,diff,d=1)
diff18w9n=apply(model518w9n,2,diff,d=1)
diff18w9nc=apply(model518w9nc,2,diff,d=1)
diff18w15n=apply(model518w15n,2,diff,d=1)
diff18w15nc=apply(model518w15nc,2,diff,d=1)
diff15w5n=apply(model515w5n,2,diff,d=1)
diff15w5nc=apply(model515w5nc,2,diff,d=1)
diff15w9=apply(model515w9,2,diff,d=1)
diff15w9c=apply(model515w9c,2,diff,d=1)
diff15w9n=apply(model515w9n,2,diff,d=1)
diff15w9nc=apply(model515w9nc,2,diff,d=1)
diff15w15n=apply(model515w15n,2,diff,d=1)
diff15w15nc=apply(model515w15nc,2,diff,d=1)

cortruef=cor(truetf,use="p")
cormodel525=cor(model525,use="p")
cormodel525c=cor(model525c,use="p")
cormodel520w3=cor(model520w3,use="p")
cormodel520w3c=cor(model520w3c,use="p")
cormodel518w5n=cor(model518w5n,use="p")
cormodel518w5nc=cor(model518w5nc,use="p")
cormodel518w9=cor(model518w9,use="p")
cormodel518w9c=cor(model518w9c,use="p")
cormodel518w9n=cor(model518w9n,use="p")
cormodel518w9nc=cor(model518w9nc,use="p")
cormodel518w15n=cor(model518w15n,use="p")
cormodel518w15nc=cor(model518w15nc,use="p")
cormodel515w5n=cor(model515w5n,use="p")
cormodel515w5nc=cor(model515w5nc,use="p")
cormodel515w9=cor(model515w9,use="p")
cormodel515w9c=cor(model515w9c,use="p")
cormodel515w9n=cor(model515w9n,use="p")
cormodel515w9nc=cor(model515w9nc,use="p")
cormodel515w15n=cor(model515w15n,use="p")
cormodel515w15nc=cor(model515w15nc,use="p")

cordifftrue=cor(difftrue,use="p")
cordiff25=cor(diff25,use="p")
cordiff25c=cor(diff25c,use="p")
cordiff20w3=cor(diff20w3,use="p")
cordiff20w3c=cor(diff20w3c,use="p")
cordiff18w5n=cor(diff18w5n,use="p")
cordiff18w5nc=cor(diff18w5nc,use="p")
cordiff18w9=cor(diff18w9,use="p")
cordiff18w9c=cor(diff18w9c,use="p")
cordiff18w9n=cor(diff18w9n,use="p")
cordiff18w9nc=cor(diff18w9nc,use="p")
cordiff18w15n=cor(diff18w15n,use="p")
cordiff18w15nc=cor(diff18w15nc,use="p")
cordiff15w5n=cor(diff15w5n,use="p")
cordiff15w5nc=cor(diff15w5nc,use="p")
cordiff15w9=cor(diff15w9,use="p")
cordiff15w9c=cor(diff15w9c,use="p")
cordiff15w9n=cor(diff15w9n,use="p")
cordiff15w9nc=cor(diff15w9nc,use="p")
cordiff15w15n=cor(diff15w15n,use="p")
cordiff15w15nc=cor(diff15w15nc,use="p")

i=1
interstattruef=NULL
interstat525=NULL
interstat525c=NULL
interstat520w3=NULL
interstat520w3c=NULL
interstat518w5n=NULL
interstat518w5nc=NULL
interstat518w9=NULL
interstat518w9c=NULL
interstat518w9n=NULL
interstat518w9nc=NULL
interstat518w15n=NULL
interstat518w15nc=NULL
interstat515w5n=NULL
interstat515w5nc=NULL
interstat515w9=NULL
interstat515w9c=NULL
interstat515w9n=NULL
interstat515w9nc=NULL
interstat515w15n=NULL
interstat515w15nc=NULL

for (i in 1:74){
	interstattruef=rbind(c(interstattruef,cortruef[(i+1):75,i]))
	interstat525=rbind(c(interstat525,cormodel525[(i+1):75,i]))
	interstat525c=rbind(c(interstat525c,cormodel525c[(i+1):75,i]))
	interstat520w3=rbind(c(interstat520w3,cormodel520w3[(i+1):75,i]))
	interstat520w3c=rbind(c(interstat520w3c,cormodel520w3c[(i+1):75,i]))
	interstat518w5n=rbind(c(interstat518w5n,cormodel518w5n[(i+1):75,i]))
	interstat518w5nc=rbind(c(interstat518w5nc,cormodel518w5nc[(i+1):75,i]))
	interstat518w9=rbind(c(interstat518w9,cormodel518w9[(i+1):75,i]))
	interstat518w9c=rbind(c(interstat518w9c,cormodel518w9c[(i+1):75,i]))
	interstat518w9n=rbind(c(interstat518w9n,cormodel518w9n[(i+1):75,i]))
	interstat518w9nc=rbind(c(interstat518w9nc,cormodel518w9nc[(i+1):75,i]))
	interstat518w15n=rbind(c(interstat518w15n,cormodel518w15n[(i+1):75,i]))
	interstat518w15nc=rbind(c(interstat518w15nc,cormodel518w15nc[(i+1):75,i]))
	interstat515w5n=rbind(c(interstat515w5n,cormodel515w5n[(i+1):75,i]))
	interstat515w5nc=rbind(c(interstat515w5nc,cormodel515w5nc[(i+1):75,i]))
	interstat515w9=rbind(c(interstat515w9,cormodel515w9[(i+1):75,i]))
	interstat515w9c=rbind(c(interstat515w9c,cormodel515w9c[(i+1):75,i]))
	interstat515w9n=rbind(c(interstat515w9n,cormodel515w9n[(i+1):75,i]))
	interstat515w9nc=rbind(c(interstat515w9nc,cormodel515w9nc[(i+1):75,i]))
	interstat515w15n=rbind(c(interstat515w15n,cormodel515w15n[(i+1):75,i]))
	interstat515w15nc=rbind(c(interstat515w15nc,cormodel515w15nc[(i+1):75,i]))
	i=i+1
}

i=1
interdifftruef=NULL
interdiff25=NULL
interdiff25c=NULL
interdiff20w3=NULL
interdiff20w3c=NULL
interdiff18w5n=NULL
interdiff18w5nc=NULL
interdiff18w9=NULL
interdiff18w9c=NULL
interdiff18w9n=NULL
interdiff18w9nc=NULL
interdiff18w15n=NULL
interdiff18w15nc=NULL
interdiff15w5n=NULL
interdiff15w5nc=NULL
interdiff15w9=NULL
interdiff15w9c=NULL
interdiff15w9n=NULL
interdiff15w9nc=NULL
interdiff15w15n=NULL
interdiff15w15nc=NULL

for (i in 1:74){
	interdifftruef=rbind(c(interdifftruef,cordifftrue[(i+1):75,i]))
	interdiff25=rbind(c(interdiff25,cordiff25[(i+1):75,i]))
	interdiff25c=rbind(c(interdiff25c,cordiff25c[(i+1):75,i]))
	interdiff20w3=rbind(c(interdiff20w3,cordiff20w3[(i+1):75,i]))
	interdiff20w3c=rbind(c(interdiff20w3c,cordiff20w3c[(i+1):75,i]))
	interdiff18w5n=rbind(c(interdiff18w5n,cordiff18w5n[(i+1):75,i]))
	interdiff18w5nc=rbind(c(interdiff18w5nc,cordiff18w5nc[(i+1):75,i]))
	interdiff18w9=rbind(c(interdiff18w9,cordiff18w9[(i+1):75,i]))
	interdiff18w9c=rbind(c(interdiff18w9c,cordiff18w9c[(i+1):75,i]))
	interdiff18w9n=rbind(c(interdiff18w9n,cordiff18w9n[(i+1):75,i]))
	interdiff18w9nc=rbind(c(interdiff18w9nc,cordiff18w9nc[(i+1):75,i]))
	interdiff18w15n=rbind(c(interdiff18w15n,cordiff18w15n[(i+1):75,i]))
	interdiff18w15nc=rbind(c(interdiff18w15nc,cordiff18w15nc[(i+1):75,i]))
	interdiff15w5n=rbind(c(interdiff15w5n,cordiff15w5n[(i+1):75,i]))
	interdiff15w5nc=rbind(c(interdiff15w5nc,cordiff15w5nc[(i+1):75,i]))
	interdiff15w9=rbind(c(interdiff15w9,cordiff15w9[(i+1):75,i]))
	interdiff15w9c=rbind(c(interdiff15w9c,cordiff15w9c[(i+1):75,i]))
	interdiff15w9n=rbind(c(interdiff15w9n,cordiff15w9n[(i+1):75,i]))
	interdiff15w9nc=rbind(c(interdiff15w9nc,cordiff15w9nc[(i+1):75,i]))
	interdiff15w15n=rbind(c(interdiff15w15n,cordiff15w15n[(i+1):75,i]))
	interdiff15w15nc=rbind(c(interdiff15w15nc,cordiff15w15nc[(i+1):75,i]))
	i=i+1
}

plot(density(interstattruef,bw=0.004),lwd=3,xlim=c(0.8,1),ylim=c(0,40),main="Density of inter-station correlations, black=observed, colours=predicted",xlab="Inter-station correlations")
lines(density(interstat525,bw=0.004),col="red",lwd=2)
lines(density(interstat525c,bw=0.004),col="red",lwd=2,lty=2)
lines(density(interstat520w3,bw=0.004),col="dark orange")
lines(density(interstat520w3c,bw=0.004),col="dark orange",lty=2)
lines(density(interstat518w5n,bw=0.004),col="orange")
lines(density(interstat518w5nc,bw=0.004),col="orange",lty=2)
lines(density(interstat518w9,bw=0.004),col="dark green")
lines(density(interstat518w9c,bw=0.004),col="dark green",lty=2)
lines(density(interstat518w9n,bw=0.004),col="blue")
lines(density(interstat518w9nc,bw=0.004),col="blue",lty=2)
lines(density(interstat518w15n,bw=0.004),col="dark blue")
lines(density(interstat518w15nc,bw=0.004),col="dark blue",lty=2)
lines(density(interstat515w5n,bw=0.004),col="purple")
lines(density(interstat515w5nc,bw=0.004),col="purple",lty=2)
lines(density(interstat515w9,bw=0.004),col="magenta")
lines(density(interstat515w9c,bw=0.004),col="magenta",lty=2)
lines(density(interstat515w9n,bw=0.004),col="pink")
lines(density(interstat515w9nc,bw=0.004),col="pink",lty=2)
lines(density(interstat515w15n,bw=0.004),col="brown")
lines(density(interstat515w15nc,bw=0.004),col="brown",lty=2)
legend(0.8,40,lty=c(1,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2),lwd=c(rep(2,21)),col=c("black","red","red","dark orange","dark orange","orange","orange","dark green","dark green","blue","blue","dark blue","dark blue", "purple","purple", "magenta", "magenta","pink","pink","brown","brown"),c("Observations","Release version - clean","Release version - corrupted","20 stats - 3 point weighted MA","20 stats - 3 point weighted MA - corrupted","18 stats - 5 point weighted MA","18 stats - 5 point weighted MA - corrupted","18 stats - 9 point weighted MA","18 stats - 9 point weighted MA - corrupted","18 stats - 9 point weighted MA - new weights","18 stats - 9 point weighted MA - new weights - corrupted","18 stats - 15 point weighted MA","18 stats - 15 point weighted MA - corrupted","15 stats - 5 point weighted MA","15 stats - 5 point weighted MA - corrupted","15 stats - 9 point weighted MA","15 stats - 9 point weighted MA - corrupted","15 stats - 9 point weighted MA - new weights","15 stats - 9 point weighted MA - new weights - corrupted","15 stats - 15 point weighted MA","15 stats - 15 point weighted MA - corrupted")) # saved as wyfc_fig2

plot(density(interstattruef,bw=0.004),lwd=3,xlim=c(0.8,1),ylim=c(0,40),main="Density of inter-station correlations, black=observed, colours=predicted",xlab="Inter-station correlations")
lines(density(interstat518w9,bw=0.004),col="dark green")
lines(density(interstat518w9c,bw=0.004),col="dark green",lty=2)
lines(density(interstat515w9,bw=0.004),col="magenta")
lines(density(interstat515w9c,bw=0.004),col="magenta",lty=2)
legend(0.8,40,lty=c(1,1,2,1,2),lwd=c(rep(2,5)),col=c("black","dark green","dark green", "magenta", "magenta"),c("Observations","18 stats - 9 point weighted MA","18 stats - 9 point weighted MA - corrupted","15 stats - 9 point weighted MA","15 stats - 9 point weighted MA - corrupted")) # saved as wyfbc_fig2

plot(density(interdifftruef,bw=0.022),lwd=3,xlim=c(0,1),ylim=c(0,5),main="Density of inter-station correlations, black=observed, colours=predicted \n Calculated between first difference series",xlab="Inter-station correlations")
lines(density(interdiff25,bw=0.022),col="red",lwd=2)
lines(density(interdiff25c,bw=0.022),col="red",lwd=2,lty=2)
lines(density(interdiff20w3,bw=0.022),col="dark orange")
lines(density(interdiff20w3c,bw=0.022),col="dark orange",lty=2)
lines(density(interdiff18w5n,bw=0.022),col="orange")
lines(density(interdiff18w5nc,bw=0.022),col="orange",lty=2)
lines(density(interdiff18w9,bw=0.022),col="dark green")
lines(density(interdiff18w9c,bw=0.022),col="dark green",lty=2)
lines(density(interdiff18w9n,bw=0.022),col="blue")
lines(density(interdiff18w9nc,bw=0.022),col="blue",lty=2)
lines(density(interdiff18w15n,bw=0.022),col="dark blue")
lines(density(interdiff18w15nc,bw=0.022),col="dark blue",lty=2)
lines(density(interdiff15w5n,bw=0.022),col="purple")
lines(density(interdiff15w5nc,bw=0.022),col="purple",lty=2)
lines(density(interdiff15w9,bw=0.022),col="magenta")
lines(density(interdiff15w9c,bw=0.022),col="magenta",lty=2)
lines(density(interdiff15w9n,bw=0.022),col="pink")
lines(density(interdiff15w9nc,bw=0.022),col="pink",lty=2)
lines(density(interdiff15w15n,bw=0.022),col="brown")
lines(density(interdiff15w15nc,bw=0.022),col="brown",lty=2)
legend(0,5,lty=c(1,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2),lwd=c(rep(2,21)),col=c("black","red","red","dark orange","dark orange","orange","orange","dark green","dark green","blue","blue","dark blue","dark blue", "purple","purple", "magenta", "magenta","pink","pink","brown","brown"),c("Observations","Release version - clean","Release version - corrupted","20 stats - 3 point weighted MA","20 stats - 3 point weighted MA - corrupted","18 stats - 5 point weighted MA","18 stats - 5 point weighted MA - corrupted","18 stats - 9 point weighted MA","18 stats - 9 point weighted MA - corrupted","18 stats - 9 point weighted MA - new weights","18 stats - 9 point weighted MA - new weights - corrupted","18 stats - 15 point weighted MA","18 stats - 15 point weighted MA - corrupted","15 stats - 5 point weighted MA","15 stats - 5 point weighted MA - corrupted","15 stats - 9 point weighted MA","15 stats - 9 point weighted MA - corrupted","15 stats - 9 point weighted MA - new weights","15 stats - 9 point weighted MA - new weights - corrupted","15 stats - 15 point weighted MA","15 stats - 15 point weighted MA - corrupted"))  # saved as wyfc_fig2a

plot(density(interdifftruef,bw=0.022),lwd=3,xlim=c(0,1),ylim=c(0,5),main="Density of inter-station correlations, black=observed, colours=predicted",xlab="Inter-station correlations")
lines(density(interdiff25,bw=0.022),col="red",lwd=2)
lines(density(interdiff25c,bw=0.022),col="red",lwd=2,lty=2)
lines(density(interdiff18w9,bw=0.022),col="dark green")
lines(density(interdiff18w9c,bw=0.022),col="dark green",lty=2)
lines(density(interdiff15w9,bw=0.022),col="magenta")
lines(density(interdiff15w9c,bw=0.022),col="magenta",lty=2)
legend(0.8,40,lty=c(1,1,2,1,2,1,2),lwd=c(rep(2,7)),col=c("black","red","red","dark green","dark green", "magenta", "magenta"),c("Observations","Release version - clean","Release version - corrupted","18 stats - 9 point weighted MA","18 stats - 9 point weighted MA - corrupted","15 stats - 9 point weighted MA","15 stats - 9 point weighted MA - corrupted")) # saved as wyfbc_fig2a

# If I can get inter-station correlations better than my first release then I'll go with that level of smoothing, if not then I'll perhaps go with the level of smoothing that most closely matches my first release

summary(interstattruef[1,]) # 0.8609 to 0.9895 med 0.9380, UQ = 0.9520, LQ = 0.9219
summary(interdifftruef[1,]) # 0.0765 to 0.8763 med 0.4831, UQ = 0.5635, LQ = 0.4003

summary(interstat525[1,]) # 0.8862 to 0.9998 med 0.9627
summary(interstat525[1,]-interstattruef[1,]) # -0.03749 to 0.10490 med 0.02244
summary(interstat525c[1,]) # 0.8857 to 0.9985 med 0.9606, LQ = 0.9477, UQ = 0.9708
summary(interstat525c[1,]-interstattruef[1,]) # -0.03652 to 0.09927 med 0.02042

summary(interdiff25[1,]) # 0.1300 to 0.9947 med 0.4972
summary(interdiff25[1,]-interdifftruef[1,]) # -0.3780 to 0.7134 med 0.004674 (so not bad at all ON AVERAGE)
summary(interdiff25c[1,]) # 0.1275 to 0.9938 med 0.4888, LQ = 0.4024, UQ = 0.5696
summary(interdiff25c[1,]-interdifftruef[1,]) # -0.3884 to 0.7125 med -0.003307

summary(interstat520w3[1,]) # 0.9104 to 0.9896 med 0.9724
summary(interstat520w3[1,]-interstattruef[1,]) # -0.003717 to 0.1077 med 0.0306
summary(interstat520w3c[1,]) # 0.9100 to 0.9888 med 0.9702
summary(interstat520w3c[1,]-interstattruef[1,]) # -0.009635 to 0.09246 med 0.02870

summary(interdiff20w3[1,]) # 0.2638 to 0.8856 med 0.7185
summary(interdiff20w3[1,]-interdifftruef[1,]) # -0.1411 to 0.7113 med 0.2041
summary(interdiff20w3c[1,]) # 0.2621 to 0.8830 med 0.7114
summary(interdiff20w3c[1,]-interdifftruef[1,]) # -0.1545 to 0.7034 med 0.2019

summary(interstat518w5n[1,]) # 0.9113 to 0.9898 med 0.9728
summary(interstat518w5n[1,]-interstattruef[1,]) # -0.003552 to 0.107700 med 0.03190
summary(interstat518w5nc[1,]) # 0.9085 to 0.9893 med 0.9705
summary(interstat518w5nc[1,]-interstattruef[1,]) # -0.006464 to 0.09073 med 0.02908

summary(interdiff18w5n[1,]) # 0.2727 to 0.8840 med 0.7168
summary(interdiff18w5n[1,]-interdifftruef[1,]) # -0.1434 to 0.7095 med 0.2023 
summary(interdiff18w5nc[1,]) # 0.2727 to 0.8811 med 0.7097
summary(interdiff18w5nc[1,]-interdifftruef[1,]) # -0.1515 to 0.7019 med 0.1958 

summary(interstat518w9[1,]) # 0.9131 to 0.9910 med 0.9741 UQ 0.9826
summary(interstat518w9[1,]-interstattruef[1,]) # -0.00275 to 0.1093 med 0.03242
summary(interstat518w9c[1,]) # 0.9093 to 0.9904 med 0.9720, LQ = 0.9601 and UQ 0.9805
summary(interstat518w9c[1,]-interstattruef[1,]) # -0.005236 to 0.0913 med 0.03039

summary(interdiff18w9[1,]) # 0.2593 to 0.8588 med 0.6901
summary(interdiff18w9[1,]-interdifftruef[1,]) # -0.1563 to 0.6823 med 0.1763 
summary(interdiff18w9c[1,]) # 0.2569 to 0.8561 med 0.6819, LQ = 0.5844, UQ = 0.7535
summary(interdiff18w9c[1,]-interdifftruef[1,]) # -0.1653 to 0.6746 med 0.1687

summary(interstat518w9n[1,]) # 0.9146 to 0.9926 med 0.9762
summary(interstat518w9n[1,]-interstattruef[1,]) # -0.00089 to 0.1114 med 0.03434
summary(interstat518w9nc[1,]) # 0.9108 to 0.9920 med 0.9739
summary(interstat518w9nc[1,]-interstattruef[1,]) # -0.003425 to 0.09329 med 0.03232

summary(interdiff18w9n[1,]) # 0.2798 to 0.9161 med 0.7537
summary(interdiff18w9n[1,]-interdifftruef[1,]) # -0.1245 to 0.7480 med 0.2364 
summary(interdiff18w9nc[1,]) # 0.2786 to 0.9128 med 0.7472
summary(interdiff18w9nc[1,]-interdifftruef[1,]) # -0.1357 to 0.7398 med 0.2309

summary(interstat518w15n[1,]) # 0.9165 to 0.9941 med 0.9780
summary(interstat518w15n[1,]-interstattruef[1,]) # 0.001518 to 0.1139 med 0.03623
summary(interstat518w15nc[1,]) # 0.9122 to 0.9933 med 0.9758
summary(interstat518w15nc[1,]-interstattruef[1,]) # -0.0007135 to 0.09656 med 0.03427

summary(interdiff18w15n[1,]) # 0.2783 to 0.9049 med 0.7410
summary(interdiff18w15n[1,]-interdifftruef[1,]) # -0.1323 to 0.7357 med 0.2251 
summary(interdiff18w15nc[1,]) # 0.2767 to 0.9013 med 0.7341
summary(interdiff18w15nc[1,]-interdifftruef[1,]) # -0.1399 to 0.7271 med 0.2191 

summary(interstat515w5n[1,]) # 0.9040 to 0.9824 med 0.9640 <- Not getting the extremes and the med is too high
summary(interstat515w5n[1,]-interstattruef[1,]) # -0.0134 to 0.09754 med 0.02216 <- Pretty close to original release
summary(interstat515w5nc[1,]) # 0.8970 to 0.9834 med 0.9614
summary(interstat515w5nc[1,]-interstattruef[1,]) # -0.01557 to 0.08147 med 0.02012

summary(interdiff15w5n[1,]) # 0.2482 to 0.8161 med 0.6454 
summary(interdiff15w5n[1,]-interdifftruef[1,]) # -0.172 to 0.6358 med 0.1340 
summary(interdiff15w5nc[1,]) # 0.2448 to 0.8277 med 0.6377
summary(interdiff15w5nc[1,]-interdifftruef[1,]) # -0.1816 to 0.6276 med 0.1261

summary(interstat515w9[1,]) # 0.9067 to 0.9844 med 0.9663
summary(interstat515w9[1,]-interstattruef[1,]) # -0.01041 to 0.1006 med 0.02449
summary(interstat515w9c[1,]) # 0.8982 to 0.9853 med 0.9638, LQ = 0.9521, UQ = 0.9721
summary(interstat515w9c[1,]-interstattruef[1,]) # -0.01328 to 0.08386 med 0.02242

summary(interdiff15w9[1,]) # 0.2291 to 0.7789 med 0.6102 REALLY losing the upper end 
summary(interdiff15w9[1,]-interdifftruef[1,]) # -0.2018 to 0.09868 med 0.59810
summary(interdiff15w9c[1,]) # 0.2286 to 0.7916 med 0.6011, LQ = 0.5152, UQ = 0.6639
summary(interdiff15w9c[1,]-interdifftruef[1,]) # -0.2068 to 0.5909 med 0.08998

summary(interstat515w9n[1,]) # 0.9093 to 0.9871 med 0.9696
summary(interstat515w9n[1,]-interstattruef[1,]) # -0.007309 to 0.1041 med 0.02779
summary(interstat515w9nc[1,]) # 0.9008 to 0.9876 med 0.9671
summary(interstat515w9nc[1,]-interstattruef[1,]) # -0.01015 to 0.08711 med 0.02572

summary(interdiff15w9n[1,]) # 0.2585 to 0.8632 med 0.6986 
summary(interdiff15w9n[1,]-interdifftruef[1,]) # -0.1481 to 0.6904 med 0.1854
summary(interdiff15w9nc[1,]) # 0.2587 to 0.8727 med 0.6923
summary(interdiff15w9nc[1,]-interdifftruef[1,]) # -0.1563 to 0.6830 med 0.1777

summary(interstat515w15n[1,]) # 0.9119 to 0.9897 med 0.9729
summary(interstat515w15n[1,]-interstattruef[1,]) # -0.004227 to 0.1083 med 0.03099
summary(interstat515w15nc[1,]) # 0.9063 to 0.9899 med 0.9705
summary(interstat515w15nc[1,]-interstattruef[1,]) # -0.005932 to 0.09187 med 0.02890

summary(interdiff15w15n[1,]) # 0.2585 to 0.8481 med 0.6801
summary(interdiff15w15n[1,]-interdifftruef[1,]) # -0.1527 to 0.6728 med 0.1673 
summary(interdiff15w15nc[1,]) # 0.2573 to 0.8539 med 0.6730
summary(interdiff15w15nc[1,]-interdifftruef[1,]) # -0.1597 to 0.6637 med 0.1593

# Look at how the inter-station correlations compare to reality (and the corrupted release version) visually:

statlist=NULL

for (i in 1:74){
	statlist=rbind(c(statlist,(i+1):75))
	i=i+1
}

statlist1=NULL

for (i in 1:74){
	statlist1=rbind(c(statlist1,(rep(i,(75-i)))))
	i=i+1
}

interstat=t(rbind(statlist1,statlist,interstattruef,interstat525c,interstat520w3c,interstat518w5nc,interstat518w9c,interstat518w9nc, interstat518w15nc,interstat515w5nc,interstat515w9c,interstat515w9nc,interstat515w15nc))

interdiff=t(rbind(statlist1,statlist,interdifftruef,interdiff25c,interdiff20w3c,interdiff18w5n,interdiff18w9,interdiff18w9n,interdiff18w15n,
interdiff15w5n,interdiff15w9,interdiff15w9n,interdiff15w15n))

par(mfrow=c(4,1))
plot(interstat[,1],interstat[,4]-interstat[,3],main="Predicted minus observed inter-station correlations - corrupted release version",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.04,0.1))
abline(h=0)
plot(interstat[,1],interstat[,5]-interstat[,3],main="Predicted minus observed inter-station correlations - 20 stats - 3 point weighted MA - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.04,0.1))
abline(h=0)
plot(interstat[,1],interstat[,6]-interstat[,3],main="Predicted minus observed inter-station correlations - 18 stats - 5 point weighted MA - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.04,0.1))
abline(h=0) 
plot(interstat[,1],interstat[,7]-interstat[,3],main="Predicted minus observed inter-station correlations - 18 stats - 9 point weighted MA - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.04,0.1))
abline(h=0) # saved as wyfc_fig3 - everything is just over-estimated more on average with these smooths compared to the first release and there is pretty much no under-estimation

par(mfrow=c(4,1))
plot(interstat[,1],interstat[,4]-interstat[,3],main="Predicted minus observed inter-station correlations - corrupted release version",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.04,0.1))
abline(h=0)
plot(interstat[,1],interstat[,8]-interstat[,3],main="Predicted minus observed inter-station correlations - 18 stats - 9 point weighted MA - new weights - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.04,0.1))
abline(h=0)
plot(interstat[,1],interstat[,9]-interstat[,3],main="Predicted minus observed inter-station correlations - 18 stats - 15 point weighted MA - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.04,0.1))
abline(h=0) 
plot(interstat[,1],interstat[,10]-interstat[,3],main="Predicted minus observed inter-station correlations - 15 stats - 5 point weighted MA - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.04,0.1))
abline(h=0) # saved as wyfc_fig3a - these 18 stat smooths result in consistent over-estimation, 15 stats and a 5 point weighted MA doesn't actually look too bad though

par(mfrow=c(4,1))
plot(interstat[,1],interstat[,4]-interstat[,3],main="Predicted minus observed inter-station correlations - corrupted release version",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.04,0.1))
abline(h=0)
plot(interstat[,1],interstat[,11]-interstat[,3],main="Predicted minus observed inter-station correlations - 15 stats - 9 point weighted MA - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.04,0.1))
abline(h=0)
plot(interstat[,1],interstat[,12]-interstat[,3],main="Predicted minus observed inter-station correlations - 15 stats - 9 point weighted MA - new weights - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.04,0.1))
abline(h=0) 
plot(interstat[,1],interstat[,13]-interstat[,3],main="Predicted minus observed inter-station correlations - 15 stats - 15 point weighted MA - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.04,0.1))
abline(h=0) # saved as wyfc_fig3b

par(mfrow=c(3,1))
plot(interstat[,1],interstat[,4]-interstat[,3],main="Predicted minus observed inter-station correlations - corrupted release version",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.04,0.1))
abline(h=0)
plot(interstat[,1],interstat[,7]-interstat[,3],main="Predicted minus observed inter-station correlations - 18 stats - 9 point weighted MA- corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.04,0.1))
abline(h=0)
plot(interstat[,1],interstat[,11]-interstat[,3],main="Predicted minus observed inter-station correlations - 15 stats - 9 point weighted MA - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.04,0.1))
abline(h=0) # saved as wyfb_fig3 

par(mfrow=c(4,1))
plot(interdiff[,1],interdiff[,4]-interdiff[,3],main="Predicted minus observed inter-station correlations - corrupted release version",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.8))
abline(h=0)
plot(interdiff[,1],interdiff[,5]-interdiff[,3],main="Predicted minus observed inter-station correlations - 20 stats - 3 point weighted MA - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.8))
abline(h=0)
plot(interdiff[,1],interdiff[,6]-interdiff[,3],main="Predicted minus observed inter-station correlations - 18 stats - 5 point weighted MA - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.8))
abline(h=0) 
plot(interdiff[,1],interdiff[,7]-interdiff[,3],main="Predicted minus observed inter-station correlations - 18 stats - 9 point weighted MA - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.8))
abline(h=0) # saved as wyfdc_fig3a - everything is just over-estimated more on average with these smooths compared to the first release and there is pretty much no under-estimation

par(mfrow=c(4,1))
plot(interdiff[,1],interdiff[,4]-interdiff[,3],main="Predicted minus observed inter-station correlations - corrupted release version",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.8))
abline(h=0)
plot(interstat[,1],interdiff[,8]-interdiff[,3],main="Predicted minus observed inter-station correlations - 18 stats - 9 point weighted MA - new weights - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.8))
abline(h=0)
plot(interdiff[,1],interdiff[,9]-interdiff[,3],main="Predicted minus observed inter-station correlations - 18 stats - 15 point weighted MA - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.8))
abline(h=0) 
plot(interdiff[,1],interdiff[,10]-interdiff[,3],main="Predicted minus observed inter-station correlations - 15 stats - 5 point weighted MA - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.8))
abline(h=0) # saved as wyfdc_fig3 - these 18 stat smooths result in consistent over-estimation, 15 stats and a 5 point weighted MA doesn't actually look too bad though

par(mfrow=c(4,1))
plot(interdiff[,1],interdiff[,4]-interdiff[,3],main="Predicted minus observed inter-station correlations - corrupted release version",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.8))
abline(h=0)
plot(interdiff[,1],interdiff[,11]-interdiff[,3],main="Predicted minus observed inter-station correlations - 15 stats - 9 point weighted MA - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.8))
abline(h=0)
plot(interdiff[,1],interdiff[,12]-interdiff[,3],main="Predicted minus observed inter-station correlations - 15 stats - 9 point weighted MA - new weights - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.8))
abline(h=0) 
plot(interdiff[,1],interdiff[,13]-interdiff[,3],main="Predicted minus observed inter-station correlations - 15 stats - 15 point weighted MA - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.8))
abline(h=0) # saved as wyfdc_fig3b

par(mfrow=c(3,1))
plot(interdiff[,1],interdiff[,4]-interdiff[,3],main="Predicted minus observed inter-station correlations - corrupted release version",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.8))
abline(h=0)
plot(interdiff[,1],interdiff[,7]-interdiff[,3],main="Predicted minus observed inter-station correlations - 18 stats - 9 point weighted MA- corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.8))
abline(h=0)
plot(interdiff[,1],interdiff[,11]-interdiff[,3],main="Predicted minus observed inter-station correlations - 15 stats - 9 point weighted MA - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.8))
abline(h=0) # saved as wyfbfc_fig3 

# Have a quick look at the density distributions - not in detail, but these quick plots should be enough to show if I have anything REALLY weird going on for any of my smooths (again I'm just looking at the corrupted data as I would expect that to match reality better):

par(mfrow=c(5,5))
for (i in 1:25){
	stat=newupsor[newupsor$Station==i,]
	plot(density(na.omit(stat$TMEAN),bw=1.4),main=paste('Station',i)) # I think this is a reasonably middling bandwidth
	lines(density(na.omit(stat$lsmodel25c,bw=1.4)),col="red")
	lines(density(na.omit(stat$lsmodel20w3c,bw=1.4)),col="dark orange")
	lines(density(na.omit(stat$lsmodel18w5nc,bw=1.4)),col="orange")
	lines(density(na.omit(stat$lsmodel18w9c,bw=1.4)),col="dark green")
	lines(density(na.omit(stat$lsmodel18w9nc,bw=1.4)),col="blue")
	lines(density(na.omit(stat$lsmodel18w15nc,bw=1.4)),col="dark blue")
	lines(density(na.omit(stat$lsmodel15w5nc,bw=1.4)),col="purple")
	lines(density(na.omit(stat$lsmodel15w9c,bw=1.4)),col="magenta")
	lines(density(na.omit(stat$lsmodel15w9nc,bw=1.4)),col="pink")
	lines(density(na.omit(stat$lsmodel15w15nc,bw=1.4)),col="brown")
} # saved wyfc_fig4_125

par(mfrow=c(5,5))
for (i in 26:50){
	stat=newupsor[newupsor$Station==i,]
	plot(density(na.omit(stat$TMEAN),bw=1.4),main=paste('Station',i)) # I think this is a reasonably middling bandwidth
	lines(density(na.omit(stat$lsmodel25c,bw=1.4)),col="red")
	lines(density(na.omit(stat$lsmodel20w3c,bw=1.4)),col="dark orange")
	lines(density(na.omit(stat$lsmodel18w5nc,bw=1.4)),col="orange")
	lines(density(na.omit(stat$lsmodel18w9c,bw=1.4)),col="dark green")
	lines(density(na.omit(stat$lsmodel18w9nc,bw=1.4)),col="blue")
	lines(density(na.omit(stat$lsmodel18w15nc,bw=1.4)),col="dark blue")
	lines(density(na.omit(stat$lsmodel15w5nc,bw=1.4)),col="purple")
	lines(density(na.omit(stat$lsmodel15w9c,bw=1.4)),col="magenta")
	lines(density(na.omit(stat$lsmodel15w9nc,bw=1.4)),col="pink")
	lines(density(na.omit(stat$lsmodel15w15nc,bw=1.4)),col="brown")
} # saved wyfc_fig4_2650

par(mfrow=c(5,5))
for (i in 51:75){
	stat=newupsor[newupsor$Station==i,]
	plot(density(na.omit(stat$TMEAN),bw=1.4),main=paste('Station',i)) # I think this is a reasonably middling bandwidth
	lines(density(na.omit(stat$lsmodel25c,bw=1.4)),col="red")
	lines(density(na.omit(stat$lsmodel20w3c,bw=1.4)),col="dark orange")
	lines(density(na.omit(stat$lsmodel18w5nc,bw=1.4)),col="orange")
	lines(density(na.omit(stat$lsmodel18w9c,bw=1.4)),col="dark green")
	lines(density(na.omit(stat$lsmodel18w9nc,bw=1.4)),col="blue")
	lines(density(na.omit(stat$lsmodel18w15nc,bw=1.4)),col="dark blue")
	lines(density(na.omit(stat$lsmodel15w5nc,bw=1.4)),col="purple")
	lines(density(na.omit(stat$lsmodel15w9c,bw=1.4)),col="magenta")
	lines(density(na.omit(stat$lsmodel15w9nc,bw=1.4)),col="pink")
	lines(density(na.omit(stat$lsmodel15w15nc,bw=1.4)),col="brown")
} # saved wyfc_fig4_5175

# Stat 47 seems to be the station with the most divergence => plot this one on its own:

i=47
stat=newupsor[newupsor$Station==i,]
plot(density(na.omit(stat$TMEAN),bw=1.4),main=paste('Station',i)) # I think this is a reasonably middling bandwidth
lines(density(na.omit(stat$lsmodel25c,bw=1.4)),col="red")
lines(density(na.omit(stat$lsmodel20w3c,bw=1.4)),col="dark orange")
lines(density(na.omit(stat$lsmodel18w5nc,bw=1.4)),col="orange")
lines(density(na.omit(stat$lsmodel18w9c,bw=1.4)),col="dark green")
lines(density(na.omit(stat$lsmodel18w9nc,bw=1.4)),col="blue")
lines(density(na.omit(stat$lsmodel18w15nc,bw=1.4)),col="dark blue")
lines(density(na.omit(stat$lsmodel15w5nc,bw=1.4)),col="purple")
lines(density(na.omit(stat$lsmodel15w9c,bw=1.4)),col="magenta")
lines(density(na.omit(stat$lsmodel15w9nc,bw=1.4)),col="pink")
lines(density(na.omit(stat$lsmodel15w15nc,bw=1.4)),col="brown") # saved as wyf_fig4_47 - can't say that any one smooth looks better than the others - different ones seem to be good at different points

############# AFTER DESEASONALISATION ####################

# Ideally I want to look at the corrupted stations after deseasonalisation (not least because this is then a time saving mechanism - but currently my corrupted stats aren't deseasonalised => need to do this before I can do anything else)

# First work out the means:

menmodel25c=as.data.frame(matrix(nrow=366,ncol=75))
menmodel20w3c=as.data.frame(matrix(nrow=366,ncol=75))
menmodel18w5nc=as.data.frame(matrix(nrow=366,ncol=75))
menmodel18w9c=as.data.frame(matrix(nrow=366,ncol=75))
menmodel18w9nc=as.data.frame(matrix(nrow=366,ncol=75))
menmodel18w15nc=as.data.frame(matrix(nrow=366,ncol=75))
menmodel15w5nc=as.data.frame(matrix(nrow=366,ncol=75))
menmodel15w9c=as.data.frame(matrix(nrow=366,ncol=75))
menmodel15w9nc=as.data.frame(matrix(nrow=366,ncol=75))
menmodel15w15nc=as.data.frame(matrix(nrow=366,ncol=75))

for (i in 1:75){
	stat=newupsor[newupsor$Station==i,]
	statn29=stat[stat$Dyear!=59.5,]
	stat29=stat[stat$Dyear==59.5,]
	
	statar25c=t(array(statn29$lsmodel25c,dim=c(365,42)))
	statar20w3c=t(array(statn29$lsmodel20w3c,dim=c(365,42)))
	statar18w5nc=t(array(statn29$lsmodel18w5nc,dim=c(365,42)))
	statar18w9c=t(array(statn29$lsmodel18w9c,dim=c(365,42)))
	statar18w9nc=t(array(statn29$lsmodel18w9nc,dim=c(365,42)))
	statar18w15nc=t(array(statn29$lsmodel18w15nc,dim=c(365,42)))
	statar15w5nc=t(array(statn29$lsmodel15w5nc,dim=c(365,42)))
	statar15w9c=t(array(statn29$lsmodel15w9c,dim=c(365,42)))
	statar15w9nc=t(array(statn29$lsmodel15w9nc,dim=c(365,42)))
	statar15w15nc=t(array(statn29$lsmodel15w15nc,dim=c(365,42)))

	menmodel25c[1:59,i]=apply(statar25c[,1:59],2,mean,na.rm=TRUE)
	menmodel20w3c[1:59,i]=apply(statar20w3c[,1:59],2,mean,na.rm=TRUE)
	menmodel18w5nc[1:59,i]=apply(statar18w5nc[,1:59],2,mean,na.rm=TRUE)
	menmodel18w9c[1:59,i]=apply(statar18w9c[,1:59],2,mean,na.rm=TRUE)
	menmodel18w9nc[1:59,i]=apply(statar18w9nc[,1:59],2,mean,na.rm=TRUE)
	menmodel18w15nc[1:59,i]=apply(statar18w15nc[,1:59],2,mean,na.rm=TRUE)
	menmodel15w5nc[1:59,i]=apply(statar15w5nc[,1:59],2,mean,na.rm=TRUE)
	menmodel15w9c[1:59,i]=apply(statar15w9c[,1:59],2,mean,na.rm=TRUE)
	menmodel15w9nc[1:59,i]=apply(statar15w9nc[,1:59],2,mean,na.rm=TRUE)
	menmodel15w15nc[1:59,i]=apply(statar15w15nc[,1:59],2,mean,na.rm=TRUE)

	menmodel25c[61:366,i]=apply(statar25c[,60:365],2,mean,na.rm=TRUE)
	menmodel20w3c[61:366,i]=apply(statar20w3c[,60:365],2,mean,na.rm=TRUE)
	menmodel18w5nc[61:366,i]=apply(statar18w5nc[,60:365],2,mean,na.rm=TRUE)
	menmodel18w9c[61:366,i]=apply(statar18w9c[,60:365],2,mean,na.rm=TRUE)
	menmodel18w9nc[61:366,i]=apply(statar18w9nc[,60:365],2,mean,na.rm=TRUE)
	menmodel18w15nc[61:366,i]=apply(statar18w15nc[,60:365],2,mean,na.rm=TRUE)
	menmodel15w5nc[61:366,i]=apply(statar15w5nc[,60:365],2,mean,na.rm=TRUE)
	menmodel15w9c[61:366,i]=apply(statar15w9c[,60:365],2,mean,na.rm=TRUE)
	menmodel15w9nc[61:366,i]=apply(statar15w9nc[,60:365],2,mean,na.rm=TRUE)
	menmodel15w15nc[61:366,i]=apply(statar15w15nc[,60:365],2,mean,na.rm=TRUE)

	menmodel25c[60,i]=mean(stat29$lsmodel25c,na.rm=TRUE)
	menmodel20w3c[60,i]=mean(stat29$lsmodel20w3c,na.rm=TRUE)
	menmodel18w5nc[60,i]=mean(stat29$lsmodel18w5nc,na.rm=TRUE)
	menmodel18w9c[60,i]=mean(stat29$lsmodel18w9c,na.rm=TRUE)
	menmodel18w9nc[60,i]=mean(stat29$lsmodel18w9nc,na.rm=TRUE)
	menmodel18w15nc[60,i]=mean(stat29$lsmodel18w15nc,na.rm=TRUE)
	menmodel15w5nc[60,i]=mean(stat29$lsmodel15w5nc,na.rm=TRUE)
	menmodel15w9c[60,i]=mean(stat29$lsmodel15w9c,na.rm=TRUE)
	menmodel15w9nc[60,i]=mean(stat29$lsmodel15w9nc,na.rm=TRUE)
	menmodel15w15nc[60,i]=mean(stat29$lsmodel15w15nc,na.rm=TRUE)
}

save(menmodel25c,menmodel20w3c,menmodel18w5nc,menmodel18w9c,menmodel18w9nc,menmodel18w15nc,menmodel15w5nc,menmodel15w9c, menmodel15w9nc,menmodel15w15nc,file='mean_wy_corrupted_second_release_91214_with_missing_data.RData')

menmodel25c1=rbind(menmodel25c[-60,],menmodel25c[-60,],menmodel25c,menmodel25c[-60,],menmodel25c[-60,],menmodel25c[-60,],menmodel25c,menmodel25c[-60,],menmodel25c[-60,],menmodel25c[-60,],menmodel25c,menmodel25c[-60,],menmodel25c[-60,],menmodel25c[-60,],menmodel25c,menmodel25c[-60,],menmodel25c[-60,],menmodel25c[-60,],menmodel25c,menmodel25c[-60,],menmodel25c[-60,],menmodel25c[-60,],menmodel25c,menmodel25c[-60,],menmodel25c[-60,],menmodel25c[-60,],menmodel25c,menmodel25c[-60,],menmodel25c[-60,],menmodel25c[-60,],menmodel25c,menmodel25c[-60,],menmodel25c[-60,],menmodel25c[-60,],menmodel25c,menmodel25c[-60,],menmodel25c[-60,],menmodel25c[-60,],menmodel25c,menmodel25c[-60,],menmodel25c[-60,],menmodel25c[-60,])
rm(menmodel25c)

menmodel20w3c1=rbind(menmodel20w3c[-60,],menmodel20w3c[-60,],menmodel20w3c,menmodel20w3c[-60,],menmodel20w3c[-60,],menmodel20w3c[-60,],menmodel20w3c,menmodel20w3c[-60,],menmodel20w3c[-60,],menmodel20w3c[-60,],menmodel20w3c,menmodel20w3c[-60,],menmodel20w3c[-60,],menmodel20w3c[-60,],menmodel20w3c,menmodel20w3c[-60,],menmodel20w3c[-60,],menmodel20w3c[-60,],menmodel20w3c,menmodel20w3c[-60,],menmodel20w3c[-60,],menmodel20w3c[-60,],menmodel20w3c,menmodel20w3c[-60,],menmodel20w3c[-60,],menmodel20w3c[-60,],menmodel20w3c,menmodel20w3c[-60,],menmodel20w3c[-60,],menmodel20w3c[-60,],menmodel20w3c,menmodel20w3c[-60,],menmodel20w3c[-60,],menmodel20w3c[-60,],menmodel20w3c,menmodel20w3c[-60,],menmodel20w3c[-60,],menmodel20w3c[-60,],menmodel20w3c,menmodel20w3c[-60,],menmodel20w3c[-60,],menmodel20w3c[-60,])
rm(menmodel20w3c)

menmodel18w5nc1=rbind(menmodel18w5nc[-60,],menmodel18w5nc[-60,],menmodel18w5nc,menmodel18w5nc[-60,],menmodel18w5nc[-60,],menmodel18w5nc[-60,],menmodel18w5nc,menmodel18w5nc[-60,],menmodel18w5nc[-60,],menmodel18w5nc[-60,],menmodel18w5nc,menmodel18w5nc[-60,],menmodel18w5nc[-60,],menmodel18w5nc[-60,],menmodel18w5nc,menmodel18w5nc[-60,],menmodel18w5nc[-60,],menmodel18w5nc[-60,],menmodel18w5nc,menmodel18w5nc[-60,],menmodel18w5nc[-60,],menmodel18w5nc[-60,],menmodel18w5nc,menmodel18w5nc[-60,],menmodel18w5nc[-60,],menmodel18w5nc[-60,],menmodel18w5nc,menmodel18w5nc[-60,],menmodel18w5nc[-60,],menmodel18w5nc[-60,],menmodel18w5nc,menmodel18w5nc[-60,],menmodel18w5nc[-60,],menmodel18w5nc[-60,],menmodel18w5nc,menmodel18w5nc[-60,],menmodel18w5nc[-60,],menmodel18w5nc[-60,],menmodel18w5nc,menmodel18w5nc[-60,],menmodel18w5nc[-60,],menmodel18w5nc[-60,])
rm(menmodel18w5nc)

menmodel18w9c1=rbind(menmodel18w9c[-60,],menmodel18w9c[-60,],menmodel18w9c,menmodel18w9c[-60,],menmodel18w9c[-60,],menmodel18w9c[-60,],menmodel18w9c,menmodel18w9c[-60,],menmodel18w9c[-60,],menmodel18w9c[-60,],menmodel18w9c,menmodel18w9c[-60,],menmodel18w9c[-60,],menmodel18w9c[-60,],menmodel18w9c,menmodel18w9c[-60,],menmodel18w9c[-60,],menmodel18w9c[-60,],menmodel18w9c,menmodel18w9c[-60,],menmodel18w9c[-60,],menmodel18w9c[-60,],menmodel18w9c,menmodel18w9c[-60,],menmodel18w9c[-60,],menmodel18w9c[-60,],menmodel18w9c,menmodel18w9c[-60,],menmodel18w9c[-60,],menmodel18w9c[-60,],menmodel18w9c,menmodel18w9c[-60,],menmodel18w9c[-60,],menmodel18w9c[-60,],menmodel18w9c,menmodel18w9c[-60,],menmodel18w9c[-60,],menmodel18w9c[-60,],menmodel18w9c,menmodel18w9c[-60,],menmodel18w9c[-60,],menmodel18w9c[-60,])
rm(menmodel18w9c)

menmodel18w9nc1=rbind(menmodel18w9nc[-60,],menmodel18w9nc[-60,],menmodel18w9nc,menmodel18w9nc[-60,],menmodel18w9nc[-60,],menmodel18w9nc[-60,],menmodel18w9nc,menmodel18w9nc[-60,],menmodel18w9nc[-60,],menmodel18w9nc[-60,],menmodel18w9nc,menmodel18w9nc[-60,],menmodel18w9nc[-60,],menmodel18w9nc[-60,],menmodel18w9nc,menmodel18w9nc[-60,],menmodel18w9nc[-60,],menmodel18w9nc[-60,],menmodel18w9nc,menmodel18w9nc[-60,],menmodel18w9nc[-60,],menmodel18w9nc[-60,],menmodel18w9nc,menmodel18w9nc[-60,],menmodel18w9nc[-60,],menmodel18w9nc[-60,],menmodel18w9nc,menmodel18w9nc[-60,],menmodel18w9nc[-60,],menmodel18w9nc[-60,],menmodel18w9nc,menmodel18w9nc[-60,],menmodel18w9nc[-60,],menmodel18w9nc[-60,],menmodel18w9nc,menmodel18w9nc[-60,],menmodel18w9nc[-60,],menmodel18w9nc[-60,],menmodel18w9nc,menmodel18w9nc[-60,],menmodel18w9nc[-60,],menmodel18w9nc[-60,])
rm(menmodel18w9nc)

menmodel18w15nc1=rbind(menmodel18w15nc[-60,],menmodel18w15nc[-60,],menmodel18w15nc,menmodel18w15nc[-60,],menmodel18w15nc[-60,],menmodel18w15nc[-60,],menmodel18w15nc,menmodel18w15nc[-60,],menmodel18w15nc[-60,],menmodel18w15nc[-60,],menmodel18w15nc,menmodel18w15nc[-60,],menmodel18w15nc[-60,],menmodel18w15nc[-60,],menmodel18w15nc,menmodel18w15nc[-60,],menmodel18w15nc[-60,],menmodel18w15nc[-60,],menmodel18w15nc,menmodel18w15nc[-60,],menmodel18w15nc[-60,],menmodel18w15nc[-60,],menmodel18w15nc,menmodel18w15nc[-60,],menmodel18w15nc[-60,],menmodel18w15nc[-60,],menmodel18w15nc,menmodel18w15nc[-60,],menmodel18w15nc[-60,],menmodel18w15nc[-60,],menmodel18w15nc,menmodel18w15nc[-60,],menmodel18w15nc[-60,],menmodel18w15nc[-60,],menmodel18w15nc,menmodel18w15nc[-60,],menmodel18w15nc[-60,],menmodel18w15nc[-60,],menmodel18w15nc,menmodel18w15nc[-60,],menmodel18w15nc[-60,],menmodel18w15nc[-60,])
rm(menmodel18w15nc)

menmodel15w5nc1=rbind(menmodel15w5nc[-60,],menmodel15w5nc[-60,],menmodel15w5nc,menmodel15w5nc[-60,],menmodel15w5nc[-60,],menmodel15w5nc[-60,],menmodel15w5nc,menmodel15w5nc[-60,],menmodel15w5nc[-60,],menmodel15w5nc[-60,],menmodel15w5nc,menmodel15w5nc[-60,],menmodel15w5nc[-60,],menmodel15w5nc[-60,],menmodel15w5nc,menmodel15w5nc[-60,],menmodel15w5nc[-60,],menmodel15w5nc[-60,],menmodel15w5nc,menmodel15w5nc[-60,],menmodel15w5nc[-60,],menmodel15w5nc[-60,],menmodel15w5nc,menmodel15w5nc[-60,],menmodel15w5nc[-60,],menmodel15w5nc[-60,],menmodel15w5nc,menmodel15w5nc[-60,],menmodel15w5nc[-60,],menmodel15w5nc[-60,],menmodel15w5nc,menmodel15w5nc[-60,],menmodel15w5nc[-60,],menmodel15w5nc[-60,],menmodel15w5nc,menmodel15w5nc[-60,],menmodel15w5nc[-60,],menmodel15w5nc[-60,],menmodel15w5nc,menmodel15w5nc[-60,],menmodel15w5nc[-60,],menmodel15w5nc[-60,])
rm(menmodel15w5nc)

menmodel15w9c1=rbind(menmodel15w9c[-60,],menmodel15w9c[-60,],menmodel15w9c,menmodel15w9c[-60,],menmodel15w9c[-60,],menmodel15w9c[-60,],menmodel15w9c,menmodel15w9c[-60,],menmodel15w9c[-60,],menmodel15w9c[-60,],menmodel15w9c,menmodel15w9c[-60,],menmodel15w9c[-60,],menmodel15w9c[-60,],menmodel15w9c,menmodel15w9c[-60,],menmodel15w9c[-60,],menmodel15w9c[-60,],menmodel15w9c,menmodel15w9c[-60,],menmodel15w9c[-60,],menmodel15w9c[-60,],menmodel15w9c,menmodel15w9c[-60,],menmodel15w9c[-60,],menmodel15w9c[-60,],menmodel15w9c,menmodel15w9c[-60,],menmodel15w9c[-60,],menmodel15w9c[-60,],menmodel15w9c,menmodel15w9c[-60,],menmodel15w9c[-60,],menmodel15w9c[-60,],menmodel15w9c,menmodel15w9c[-60,],menmodel15w9c[-60,],menmodel15w9c[-60,],menmodel15w9c,menmodel15w9c[-60,],menmodel15w9c[-60,],menmodel15w9c[-60,])
rm(menmodel15w9c)

menmodel15w9nc1=rbind(menmodel15w9nc[-60,],menmodel15w9nc[-60,],menmodel15w9nc,menmodel15w9nc[-60,],menmodel15w9nc[-60,],menmodel15w9nc[-60,],menmodel15w9nc,menmodel15w9nc[-60,],menmodel15w9nc[-60,],menmodel15w9nc[-60,],menmodel15w9nc,menmodel15w9nc[-60,],menmodel15w9nc[-60,],menmodel15w9nc[-60,],menmodel15w9nc,menmodel15w9nc[-60,],menmodel15w9nc[-60,],menmodel15w9nc[-60,],menmodel15w9nc,menmodel15w9nc[-60,],menmodel15w9nc[-60,],menmodel15w9nc[-60,],menmodel15w9nc,menmodel15w9nc[-60,],menmodel15w9nc[-60,],menmodel15w9nc[-60,],menmodel15w9nc,menmodel15w9nc[-60,],menmodel15w9nc[-60,],menmodel15w9nc[-60,],menmodel15w9nc,menmodel15w9nc[-60,],menmodel15w9nc[-60,],menmodel15w9nc[-60,],menmodel15w9nc,menmodel15w9nc[-60,],menmodel15w9nc[-60,],menmodel15w9nc[-60,],menmodel15w9nc,menmodel15w9nc[-60,],menmodel15w9nc[-60,],menmodel15w9nc[-60,])
rm(menmodel15w9nc)

menmodel15w15nc1=rbind(menmodel15w15nc[-60,],menmodel15w15nc[-60,],menmodel15w15nc,menmodel15w15nc[-60,],menmodel15w15nc[-60,],menmodel15w15nc[-60,],menmodel15w15nc,menmodel15w15nc[-60,],menmodel15w15nc[-60,],menmodel15w15nc[-60,],menmodel15w15nc,menmodel15w15nc[-60,],menmodel15w15nc[-60,],menmodel15w15nc[-60,],menmodel15w15nc,menmodel15w15nc[-60,],menmodel15w15nc[-60,],menmodel15w15nc[-60,],menmodel15w15nc,menmodel15w15nc[-60,],menmodel15w15nc[-60,],menmodel15w15nc[-60,],menmodel15w15nc,menmodel15w15nc[-60,],menmodel15w15nc[-60,],menmodel15w15nc[-60,],menmodel15w15nc,menmodel15w15nc[-60,],menmodel15w15nc[-60,],menmodel15w15nc[-60,],menmodel15w15nc,menmodel15w15nc[-60,],menmodel15w15nc[-60,],menmodel15w15nc[-60,],menmodel15w15nc,menmodel15w15nc[-60,],menmodel15w15nc[-60,],menmodel15w15nc[-60,],menmodel15w15nc,menmodel15w15nc[-60,],menmodel15w15nc[-60,],menmodel15w15nc[-60,])
rm(menmodel15w15nc)

save(menmodel25c1,menmodel20w3c1,menmodel18w5nc1,menmodel18w9c1,menmodel18w9nc1,menmodel18w15nc1,menmodel15w5nc1,menmodel15w9c1, menmodel15w9nc1,menmodel15w15nc1,file='meantab_wy_corrupted_second_release_91214_with_missing_data.RData')

# Now is it easier to put the predicted series in table form or the measns in column form (I think the former - as long as the subtraction still works then (it does as long as you loop over the columns instead of trying to do it all in one go I think...)

# Create data frames to store the predictions in in a column by column format

model25c=as.data.frame(matrix(nrow=15340,ncol=75))
model20w3c=as.data.frame(matrix(nrow=15340,ncol=75))
model18w5nc=as.data.frame(matrix(nrow=15340,ncol=75))
model18w9c=as.data.frame(matrix(nrow=15340,ncol=75))
model18w9nc=as.data.frame(matrix(nrow=15340,ncol=75))
model18w15nc=as.data.frame(matrix(nrow=15340,ncol=75))
model15w5nc=as.data.frame(matrix(nrow=15340,ncol=75))
model15w9c=as.data.frame(matrix(nrow=15340,ncol=75))
model15w9nc=as.data.frame(matrix(nrow=15340,ncol=75))
model15w15nc=as.data.frame(matrix(nrow=15340,ncol=75))

# Fill the data frames with predictions in a column by column format for each station

for (i in 1:75){
	new1=newupsor[newupsor$Station==i,]
	model25c[,i]=new1$lsmodel25c
	model20w3c[,i]=new1$lsmodel20w3c
	model18w5nc[,i]=new1$lsmodel18w5nc
	model18w9c[,i]=new1$lsmodel18w9c
	model18w9nc[,i]=new1$lsmodel18w9nc
	model18w15nc[,i]=new1$lsmodel18w15nc
	model15w5nc[,i]=new1$lsmodel15w5nc
	model15w9c[,i]=new1$lsmodel15w9c
	model15w9nc[,i]=new1$lsmodel15w9nc
	model15w15nc[,i]=new1$lsmodel15w15nc
}

# Create data frames for the deseasonalised values - one column for each station:

deseason25c=as.data.frame(matrix(nrow=15340,ncol=75))
deseason20w3c=as.data.frame(matrix(nrow=15340,ncol=75))
deseason18w5nc=as.data.frame(matrix(nrow=15340,ncol=75))
deseason18w9c=as.data.frame(matrix(nrow=15340,ncol=75))
deseason18w9nc=as.data.frame(matrix(nrow=15340,ncol=75))
deseason18w15nc=as.data.frame(matrix(nrow=15340,ncol=75))
deseason15w5nc=as.data.frame(matrix(nrow=15340,ncol=75))
deseason15w9c=as.data.frame(matrix(nrow=15340,ncol=75))
deseason15w9nc=as.data.frame(matrix(nrow=15340,ncol=75))
deseason15w15nc=as.data.frame(matrix(nrow=15340,ncol=75))

# Fill the data frames by subtracting the mean for each station from the prediction for each station on a column by column basis:

for (i in 1:75){
	deseason25c[,i]=model25c[,i]-menmodel25c1[,i]
	deseason20w3c[,i]=model20w3c[,i]-menmodel20w3c1[,i]
	deseason18w5nc[,i]=model18w5nc[,i]-menmodel18w5nc1[,i]
	deseason18w9c[,i]=model18w9c[,i]-menmodel18w9c1[,i]
	deseason18w9nc[,i]=model18w9nc[,i]-menmodel18w9nc1[,i]
	deseason18w15nc[,i]=model18w15nc[,i]-menmodel18w15nc1[,i]
	deseason15w5nc[,i]=model15w5nc[,i]-menmodel15w5nc1[,i]
	deseason15w9c[,i]=model15w9c[,i]-menmodel15w9c1[,i]
	deseason15w9nc[,i]=model15w9nc[,i]-menmodel15w9nc1[,i]
	deseason15w15nc[,i]=model15w15nc[,i]-menmodel15w15nc1[,i]
}

save(deseason25c,deseason20w3c,deseason18w5nc,deseason18w9c,deseason18w9nc,deseason18w15nc,deseason15w5nc,deseason15w9c, deseason15w9nc,deseason15w15nc,file='deseasontab_wy_corrupted_second_release_91214_with_missing_data.RData')

load('/scratch/rw307/Reading/Scripts/Wyoming_new/ClusterScripts/ModelOutputs/SIngle_relocation_option/Re-runs/Full_time_period/deseasontab_wy_comp_2914_observations_smaller_full.RData')
# deseasont = Observations

# Now I have the observations and the corrupted versions deseasonalised - these will be what I focus on

# Get the deseasonalised inter-station correlations:

deseasontc=cor(deseasont,use="p")
deseason25cor=cor(deseason25c,use="p")
deseason20w3cor=cor(deseason20w3c,use="p")
deseason18w5ncor=cor(deseason18w5nc,use="p")
deseason18w9cor=cor(deseason18w9c,use="p")
deseason18w9ncor=cor(deseason18w9nc,use="p")
deseason18w15ncor=cor(deseason18w15nc,use="p")
deseason15w5ncor=cor(deseason15w5nc,use="p")
deseason15w9cor=cor(deseason15w9c,use="p")
deseason15w9ncor=cor(deseason15w9nc,use="p")
deseason15w15ncor=cor(deseason15w15nc,use="p")

# Get the first differences of all these deseasonalised stations:

deseasontf=apply(deseasont,2,diff,d=1)
deseason25cf=apply(deseason25c,2,diff,d=1)
deseason20w3cf=apply(deseason20w3c,2,diff,d=1)
deseason18w5ncf=apply(deseason18w5nc,2,diff,d=1)
deseason18w9cf=apply(deseason18w9c,2,diff,d=1)
deseason18w9ncf=apply(deseason18w9nc,2,diff,d=1)
deseason18w15ncf=apply(deseason18w15nc,2,diff,d=1)
deseason15w5ncf=apply(deseason15w5nc,2,diff,d=1)
deseason15w9cf=apply(deseason15w9c,2,diff,d=1)
deseason15w9ncf=apply(deseason15w9nc,2,diff,d=1)
deseason15w15ncf=apply(deseason15w15nc,2,diff,d=1)

# And get the correlations between the first differenced series of the original stats (which is what would normally be used for finding the most highly correlated neighbour):

deseasontcf=cor(deseasontf,use="p")
deseason25cfcor=cor(deseason25cf,use="p")
deseason20w3cfcor=cor(deseason20w3cf,use="p")
deseason18w5ncfcor=cor(deseason18w5ncf,use="p")
deseason18w9cfcor=cor(deseason18w9cf,use="p")
deseason18w9ncfcor=cor(deseason18w9ncf,use="p")
deseason18w15ncfcor=cor(deseason18w15ncf,use="p")
deseason15w5ncfcor=cor(deseason15w5ncf,use="p")
deseason15w9cfcor=cor(deseason15w9cf,use="p")
deseason15w9ncfcor=cor(deseason15w9ncf,use="p")
deseason15w15ncfcor=cor(deseason15w15ncf,use="p")

# Get the inter-station correlations (the original way) in one long list:

interstatde=NULL
interstat25cde=NULL
interstat20w3cde=NULL
interstat18w5ncde=NULL
interstat18w9cde=NULL
interstat18w9ncde=NULL
interstat18w15ncde=NULL
interstat15w5ncde=NULL
interstat15w9cde=NULL
interstat15w9ncde=NULL
interstat15w15ncde=NULL

for(i in 1:74){
	interstatde=rbind(c(interstatde,deseasontc[(i+1):75,i]))
	interstat25cde=rbind(c(interstat25cde,deseason25cor[(i+1):75,i]))
	interstat20w3cde=rbind(c(interstat20w3cde,deseason20w3cor[(i+1):75,i]))
	interstat18w5ncde=rbind(c(interstat18w5ncde,deseason18w5ncor[(i+1):75,i]))
	interstat18w9cde=rbind(c(interstat18w9cde,deseason18w9cor[(i+1):75,i]))
	interstat18w9ncde=rbind(c(interstat18w9ncde,deseason18w9ncor[(i+1):75,i]))
	interstat18w15ncde=rbind(c(interstat18w15ncde,deseason18w15ncor[(i+1):75,i]))
	interstat15w5ncde=rbind(c(interstat15w5ncde,deseason15w5ncor[(i+1):75,i]))
	interstat15w9cde=rbind(c(interstat15w9cde,deseason15w9cor[(i+1):75,i]))
	interstat15w9ncde=rbind(c(interstat15w9ncde,deseason15w9ncor[(i+1):75,i]))
	interstat15w15ncde=rbind(c(interstat15w15ncde,deseason15w15ncor[(i+1):75,i]))
}

# Get the interstation correlations calculated from the first difference series into one long list:

interstatdef=NULL
interstat25cdef=NULL
interstat20w3cdef=NULL
interstat18w5ncdef=NULL
interstat18w9cdef=NULL
interstat18w9ncdef=NULL
interstat18w15ncdef=NULL
interstat15w5ncdef=NULL
interstat15w9cdef=NULL
interstat15w9ncdef=NULL
interstat15w15ncdef=NULL

for(i in 1:74){
	interstatdef=rbind(c(interstatdef,deseasontcf[(i+1):75,i]))
	interstat25cdef=rbind(c(interstat25cdef,deseason25cfcor[(i+1):75,i]))
	interstat20w3cdef=rbind(c(interstat20w3cdef,deseason20w3cfcor[(i+1):75,i]))
	interstat18w5ncdef=rbind(c(interstat18w5ncdef,deseason18w5ncfcor[(i+1):75,i]))
	interstat18w9cdef=rbind(c(interstat18w9cdef,deseason18w9cfcor[(i+1):75,i]))
	interstat18w9ncdef=rbind(c(interstat18w9ncdef,deseason18w9ncfcor[(i+1):75,i]))
	interstat18w15ncdef=rbind(c(interstat18w15ncdef,deseason18w15ncfcor[(i+1):75,i]))
	interstat15w5ncdef=rbind(c(interstat15w5ncdef,deseason15w5ncfcor[(i+1):75,i]))
	interstat15w9cdef=rbind(c(interstat15w9cdef,deseason15w9cfcor[(i+1):75,i]))
	interstat15w9ncdef=rbind(c(interstat15w9ncdef,deseason15w9ncfcor[(i+1):75,i]))
	interstat15w15ncdef=rbind(c(interstat15w15ncdef,deseason15w15ncfcor[(i+1):75,i]))
}

# Look at inter-station correlations (after deseasonalisation) against distances between stations:

# Get the distances between stations:

library(fields)

day1101=newupsor[newupsor$Time==11324,]
dist1101=rdist.earth(cbind(day1101$Long,day1101$Lat),miles=FALSE)

# Get the distances in one long column without duplicates and without the distance between a station and itself:

dist=NULL

for (i in 1:74){
	dist=rbind(c(dist,dist1101[(i+1):75,i]))
	i=i+1
}

par(mfrow=c(3,4))
plot(dist,interstat25cde[1,]-interstatde[1,],xlab="Distance (km)",ylab="Pred-obs inter-stat corrs",main="25 stations = first release",ylim=c(-0.25,0.4))
abline(h=0,col="red")
plot(dist,interstat20w3cde[1,]-interstatde[1,],xlab="Distance (km)",ylab="Pred-obs inter-stat corrs",main="20 stations - 3 point weighted MA",ylim=c(-0.25,0.4))
abline(h=0,col="red")
plot(dist,interstat18w5ncde[1,]-interstatde[1,],xlab="Distance (km)",ylab="Pred-obs inter-stat corrs",main="18 stations - 5 point weighted MA",ylim=c(-0.25,0.4))
abline(h=0,col="red")
plot(dist,interstat18w9cde[1,]-interstatde[1,],xlab="Distance (km)",ylab="Pred-obs inter-stat corrs",main="18 stations - 9 point weighted MA",ylim=c(-0.25,0.4))
abline(h=0,col="red")
plot(dist,interstat18w9ncde[1,]-interstatde[1,],xlab="Distance (km)",ylab="Pred-obs inter-stat corrs",main="18 stations - 9 point weighted MA - new weights",ylim=c(-0.25,0.4))
abline(h=0,col="red")
plot(dist,interstat18w15ncde[1,]-interstatde[1,],xlab="Distance (km)",ylab="Pred-obs inter-stat corrs",main="18 stations - 5 point weighted MA",ylim=c(-0.25,0.4))
abline(h=0,col="red")
plot(dist,interstat15w5ncde[1,]-interstatde[1,],xlab="Distance (km)",ylab="Pred-obs inter-stat corrs",main="15 stations - 5 point weighted MA",ylim=c(-0.25,0.4))
abline(h=0,col="red")
plot(dist,interstat15w9cde[1,]-interstatde[1,],xlab="Distance (km)",ylab="Pred-obs inter-stat corrs",main="15 stations - 9 point weighted MA",ylim=c(-0.25,0.4))
abline(h=0,col="red")
plot(dist,interstat15w9ncde[1,]-interstatde[1,],xlab="Distance (km)",ylab="Pred-obs inter-stat corrs",main="15 stations - 9 point weighted MA - new weights",ylim=c(-0.25,0.4))
abline(h=0,col="red")
plot(dist,interstat15w15ncde[1,]-interstatde[1,],xlab="Distance (km)",ylab="Pred-obs inter-stat corrs",main="15 stations - 15 point weighted MA",ylim=c(-0.25,0.4))
abline(h=0,col="red") # saved as wyfc_fig5

# As above, but actual inter-station correlations not predicted minus observed

par(mfrow=c(3,4))
plot(dist,interstatde[1,],xlab="Distance (km)",ylab="Inter-stat corrs",main="Observed",ylim=c(0,1))
plot(dist,interstat25cde[1,],xlab="Distance (km)",ylab="Inter-stat corrs",main="25 stations = first release",ylim=c(0,1))
plot(dist,interstat20w3cde[1,],xlab="Distance (km)",ylab="Inter-stat corrs",main="20 stations - 3 point weighted MA",ylim=c(0,1))
plot(dist,interstat18w5ncde[1,],xlab="Distance (km)",ylab="Inter-stat corrs",main="18 stations - 5 point weighted MA",ylim=c(0,1))
plot(dist,interstat18w9cde[1,],xlab="Distance (km)",ylab="Inter-stat corrs",main="18 stations - 9 point weighted MA",ylim=c(0,1))
plot(dist,interstat18w9ncde[1,],xlab="Distance (km)",ylab="Inter-stat corrs",main="18 stations - 9 point weighted MA - new weights",ylim=c(0,1))
plot(dist,interstat18w15ncde[1,],xlab="Distance (km)",ylab="Inter-stat corrs",main="18 stations - 5 point weighted MA",ylim=c(0,1))
plot(dist,interstat15w5ncde[1,],xlab="Distance (km)",ylab="Inter-stat corrs",main="15 stations - 5 point weighted MA",ylim=c(0,1))
plot(dist,interstat15w9cde[1,],xlab="Distance (km)",ylab="Inter-stat corrs",main="15 stations - 9 point weighted MA",ylim=c(0,1))
plot(dist,interstat15w9ncde[1,],xlab="Distance (km)",ylab="Inter-stat corrs",main="15 stations - 9 point weighted MA - new weights",ylim=c(0,1))
plot(dist,interstat15w15ncde[1,],xlab="Distance (km)",ylab="Inter-stat corrs",main="15 stations - 15 point weighted MA",ylim=c(0,1)) # saved as wyfc_fig5a - There's one point that seems much lower for seemingly any level of smoothing - strange!
 
# Now look at the equaivalent plots, but where the inter-station correlations have been calculated from first difference series:

par(mfrow=c(3,4))
plot(dist,interstat25cdef[1,]-interstatdef[1,],xlab="Distance (km)",ylab="Pred-obs inter-stat corrs",main="25 stations = first release",ylim=c(-0.5,0.7))
abline(h=0,col="red")
plot(dist,interstat20w3cdef[1,]-interstatdef[1,],xlab="Distance (km)",ylab="Pred-obs inter-stat corrs",main="20 stations - 3 point weighted MA",ylim=c(-0.5,0.7))
abline(h=0,col="red")
plot(dist,interstat18w5ncdef[1,]-interstatdef[1,],xlab="Distance (km)",ylab="Pred-obs inter-stat corrs",main="18 stations - 5 point weighted MA",ylim=c(-0.5,0.7))
abline(h=0,col="red")
plot(dist,interstat18w9cdef[1,]-interstatdef[1,],xlab="Distance (km)",ylab="Pred-obs inter-stat corrs",main="18 stations - 9 point weighted MA",ylim=c(-0.5,0.7))
abline(h=0,col="red")
plot(dist,interstat18w9ncdef[1,]-interstatdef[1,],xlab="Distance (km)",ylab="Pred-obs inter-stat corrs",main="18 stations - 9 point weighted MA - new weights",ylim=c(-0.5,0.7))
abline(h=0,col="red")
plot(dist,interstat18w15ncdef[1,]-interstatdef[1,],xlab="Distance (km)",ylab="Pred-obs inter-stat corrs",main="18 stations - 5 point weighted MA",ylim=c(-0.5,0.7))
abline(h=0,col="red")
plot(dist,interstat15w5ncdef[1,]-interstatdef[1,],xlab="Distance (km)",ylab="Pred-obs inter-stat corrs",main="15 stations - 5 point weighted MA",ylim=c(-0.5,0.7))
abline(h=0,col="red")
plot(dist,interstat15w9cdef[1,]-interstatdef[1,],xlab="Distance (km)",ylab="Pred-obs inter-stat corrs",main="15 stations - 9 point weighted MA",ylim=c(-0.5,0.7))
abline(h=0,col="red")
plot(dist,interstat15w9ncdef[1,]-interstatdef[1,],xlab="Distance (km)",ylab="Pred-obs inter-stat corrs",main="15 stations - 9 point weighted MA - new weights",ylim=c(-0.5,0.7))
abline(h=0,col="red")
plot(dist,interstat15w15ncdef[1,]-interstatdef[1,],xlab="Distance (km)",ylab="Pred-obs inter-stat corrs",main="15 stations - 15 point weighted MA",ylim=c(-0.5,0.7))
abline(h=0,col="red") # saved as wyfc_fig5b

# As above, but actual inter-station correlations not predicted minus observed

par(mfrow=c(3,4))
plot(dist,interstatdef[1,],xlab="Distance (km)",ylab="Inter-stat corrs",main="Observed",ylim=c(0,1))
plot(dist,interstat25cdef[1,],xlab="Distance (km)",ylab="Inter-stat corrs",main="25 stations = first release",ylim=c(0,1))
plot(dist,interstat20w3cdef[1,],xlab="Distance (km)",ylab="Inter-stat corrs",main="20 stations - 3 point weighted MA",ylim=c(0,1))
plot(dist,interstat18w5ncdef[1,],xlab="Distance (km)",ylab="Inter-stat corrs",main="18 stations - 5 point weighted MA",ylim=c(0,1))
plot(dist,interstat18w9cdef[1,],xlab="Distance (km)",ylab="Inter-stat corrs",main="18 stations - 9 point weighted MA",ylim=c(0,1))
plot(dist,interstat18w9ncdef[1,],xlab="Distance (km)",ylab="Inter-stat corrs",main="18 stations - 9 point weighted MA - new weights",ylim=c(0,1))
plot(dist,interstat18w15ncdef[1,],xlab="Distance (km)",ylab="Inter-stat corrs",main="18 stations - 5 point weighted MA",ylim=c(0,1))
plot(dist,interstat15w5ncdef[1,],xlab="Distance (km)",ylab="Inter-stat corrs",main="15 stations - 5 point weighted MA",ylim=c(0,1))
plot(dist,interstat15w9cdef[1,],xlab="Distance (km)",ylab="Inter-stat corrs",main="15 stations - 9 point weighted MA",ylim=c(0,1))
plot(dist,interstat15w9ncdef[1,],xlab="Distance (km)",ylab="Inter-stat corrs",main="15 stations - 9 point weighted MA - new weights",ylim=c(0,1))
plot(dist,interstat15w15ncdef[1,],xlab="Distance (km)",ylab="Inter-stat corrs",main="15 stations - 15 point weighted MA",ylim=c(0,1)) # saved as wyfc_fig5c - It would appear that this is the one plot I forgot to save last time so I can't see if the inter-station correlations really do look lower or not! (At least, I can't look without re-running all the rest of the code again!)

# Have a look at what proportion of inter-station correlations are being under-estimated (and by how much) at different distances:

fred=as.data.frame(matrix(nrow=2775,ncol=11))
fred[,1]=t(dist)
fred[,2]=t(interstat25cde-interstatde)
fred[,3]=t(interstat20w3cde-interstatde)
fred[,4]=t(interstat18w5ncde-interstatde)
fred[,5]=t(interstat18w9cde-interstatde)
fred[,6]=t(interstat18w9ncde-interstatde)
fred[,7]=t(interstat18w15ncde-interstatde)
fred[,8]=t(interstat15w5ncde-interstatde)
fred[,9]=t(interstat15w9cde-interstatde)
fred[,10]=t(interstat15w9ncde-interstatde)
fred[,11]=t(interstat15w15ncde-interstatde)

# Out of 76:
dim(fred[fred[,2]<0 & fred[,1]<50,]) # 3	25c
dim(fred[fred[,3]<0 & fred[,1]<50,]) # 7	20w3c
dim(fred[fred[,4]<0 & fred[,1]<50,]) # 7	18w5nc
dim(fred[fred[,5]<0 & fred[,1]<50,]) # 7	18w9c
dim(fred[fred[,6]<0 & fred[,1]<50,]) # 4	18w9nc
dim(fred[fred[,7]<0 & fred[,1]<50,]) # 2	18w15nc
dim(fred[fred[,8]<0 & fred[,1]<50,]) # 36 	15w5nc
dim(fred[fred[,9]<0 & fred[,1]<50,]) # 27 	15w9c
dim(fred[fred[,10]<0 & fred[,1]<50,]) # 15 	15w9nc
dim(fred[fred[,11]<0 & fred[,1]<50,]) # 7 	15w15nc

# Out of 285:
dim(fred[fred[,2]<0 & fred[,1]<100,]) # 56	25c 
dim(fred[fred[,3]<0 & fred[,1]<100,]) # 23	20w3c
dim(fred[fred[,4]<0 & fred[,1]<100,]) # 22	18w5nc
dim(fred[fred[,5]<0 & fred[,1]<100,]) # 18	18w9c
dim(fred[fred[,6]<0 & fred[,1]<100,]) # 10	18w9nc
dim(fred[fred[,7]<0 & fred[,1]<100,]) # 5	18w15nc
dim(fred[fred[,8]<0 & fred[,1]<100,]) # 104 	15w5nc
dim(fred[fred[,9]<0 & fred[,1]<100,]) # 77 	15w9c
dim(fred[fred[,10]<0 & fred[,1]<100,]) # 47 	15w9nc
dim(fred[fred[,11]<0 & fred[,1]<100,]) # 20	15w15nc

# Out of 2775:
dim(fred[fred[,2]<0,]) # 997	25c
dim(fred[fred[,3]<0,]) # 412	20w3c
dim(fred[fred[,4]<0,]) # 392	18w5nc
dim(fred[fred[,5]<0,]) # 334	18w9c
dim(fred[fred[,6]<0,]) # 272	18w9nc
dim(fred[fred[,7]<0,]) # 210	18w15nc
dim(fred[fred[,8]<0,]) # 978 	15w5nc
dim(fred[fred[,9]<0,]) # 810	15w9c
dim(fred[fred[,10]<0,]) # 592 	15w9nc
dim(fred[fred[,11]<0,]) # 387	15w15nc

# Looking at the median amount of over/under-estimation taking everything into account:

median(fred[,2]) # 0.029	25c 
median(fred[,3]) # 0.068	20w3c
median(fred[,4]) # 0.070	18w5n
median(fred[,5]) # 0.077	18w9
median(fred[,6]) # 0.087	18w9n
median(fred[,7]) # 0.098	18w15n
median(fred[,8]) # 0.024	15w5n
median(fred[,9]) # 0.035	15w9
median(fred[,10]) # 0.052	15w9n
median(fred[,11]) # 0.068	15w15n

# Now do the same for the inter-station correlations calculated from the first difference series:

fredf=as.data.frame(matrix(nrow=2775,ncol=11))
fredf[,1]=t(dist)
fredf[,2]=t(interstat25cdef-interstatdef)
fredf[,3]=t(interstat20w3cdef-interstatdef)
fredf[,4]=t(interstat18w5ncdef-interstatdef)
fredf[,5]=t(interstat18w9cdef-interstatdef)
fredf[,6]=t(interstat18w9ncdef-interstatdef)
fredf[,7]=t(interstat18w15ncdef-interstatdef)
fredf[,8]=t(interstat15w5ncdef-interstatdef)
fredf[,9]=t(interstat15w9cdef-interstatdef)
fredf[,10]=t(interstat15w9ncdef-interstatdef)
fredf[,11]=t(interstat15w15ncdef-interstatdef)

# Out of 76:
dim(fredf[fredf[,2]<0 & fredf[,1]<50,]) # 6	25c
dim(fredf[fredf[,3]<0 & fredf[,1]<50,]) # 2	20w3c
dim(fredf[fredf[,4]<0 & fredf[,1]<50,]) # 2	18w5nc
dim(fredf[fredf[,5]<0 & fredf[,1]<50,]) # 2	18w9c
dim(fredf[fredf[,6]<0 & fredf[,1]<50,]) # 0	18w9nc
dim(fredf[fredf[,7]<0 & fredf[,1]<50,]) # 0	18w15nc
dim(fredf[fredf[,8]<0 & fredf[,1]<50,]) # 5 	15w5nc
dim(fredf[fredf[,9]<0 & fredf[,1]<50,]) # 13 	15w9c
dim(fredf[fredf[,10]<0 & fredf[,1]<50,]) # 2 	15w9nc
dim(fredf[fredf[,11]<0 & fredf[,1]<50,]) # 2 	15w15nc

# Out of 285:
dim(fredf[fredf[,2]<0 & fredf[,1]<100,]) # 84	25c
dim(fredf[fredf[,3]<0 & fredf[,1]<100,]) # 2	20w3c
dim(fredf[fredf[,4]<0 & fredf[,1]<100,]) # 2	18w5nc
dim(fredf[fredf[,5]<0 & fredf[,1]<100,]) # 4	18w9c
dim(fredf[fredf[,6]<0 & fredf[,1]<100,]) # 0	18w9nc
dim(fredf[fredf[,7]<0 & fredf[,1]<100,]) # 0	18w15nc
dim(fredf[fredf[,8]<0 & fredf[,1]<100,]) # 19 	15w5nc
dim(fredf[fredf[,9]<0 & fredf[,1]<100,]) # 39 	15w9c
dim(fredf[fredf[,10]<0 & fredf[,1]<100,]) # 4 	15w9nc
dim(fredf[fredf[,11]<0 & fredf[,1]<100,]) # 7	15w15nc

# Out of 2775:
dim(fredf[fredf[,2]<0,]) # 1405	25c
dim(fredf[fredf[,3]<0,]) # 128	20w3c
dim(fredf[fredf[,4]<0,]) # 128	18w5nc
dim(fredf[fredf[,5]<0,]) # 180	18w9c
dim(fredf[fredf[,6]<0,]) # 91	18w9nc
dim(fredf[fredf[,7]<0,]) # 103	18w15nc
dim(fredf[fredf[,8]<0,]) # 315 	15w5nc
dim(fredf[fredf[,9]<0,]) # 514	15w9c # CANNOT UNDERSTAND why 15w9c does so much worse than 15w5nc???
dim(fredf[fredf[,10]<0,]) # 160 15w9nc
dim(fredf[fredf[,11]<0,]) # 200 15w15nc

# Looking at the mean amount of over/under-estimation taking everything into account:

median(fredf[,2]) # -0.002	25c
median(fredf[,3]) # 0.196	20w3c
median(fredf[,4]) # 0.194	18w5n
median(fredf[,5]) # 0.168	18w9
median(fredf[,6]) # 0.230	18w9n
median(fredf[,7]) # 0.217	18w15n
median(fredf[,8]) # 0.126	15w5n
median(fredf[,9]) # 0.089	15w9
median(fredf[,10]) # 0.177	15w9n
median(fredf[,11]) # 0.158	15w15n

# Have a look at summaries of observed and predicted inter-station correlations (after deseasonalisation and corruption):

summary(interstatde[1,]) # 0.3985 to 0.9578 med 0.7329

summary(interstat25cde[1,]) # 0.3517 to 0.9897 med 0.7671 
summary(interstat25cde[1,]-interstatde[1,]) # -0.2248 to 0.2991 med 0.02891

summary(interstat20w3cde[1,]) # 0.4212 to 0.9360 med 0.8154 
summary(interstat20w3cde[1,]-interstatde[1,]) # -0.1723 to 0.3095 med 0.06841

summary(interstat18w5ncde[1,]) # 0.4226 to 0.9387 med 0.8166 <- Losing the upper end 
summary(interstat18w5ncde[1,]-interstatde[1,]) # -0.1741 to 0.3008 med 0.06958

summary(interstat18w9cde[1,]) # 0.4264 to 0.9449 med 0.8246 <- Still losing the upper end, but not as much 
summary(interstat18w9cde[1,]-interstatde[1,]) # -0.1655 to 0.3038 med 0.07698

summary(interstat18w9ncde[1,]) # 0.4314 to 0.9529 med 0.8347 <- Median still being over-estimated, but upper end getting closer 
summary(interstat18w9ncde[1,]-interstatde[1,]) # -0.1612 to 0.3154 med 0.08699

summary(interstat18w15ncde[1,]) # 0.4373 to 0.9609 med 0.8459 
summary(interstat18w15ncde[1,]-interstatde[1,]) # -0.1545 to 0.3318 med 0.09834

summary(interstat15w5ncde[1,]) # 0.3981 to 0.9076 med 0.7705 <- Median closer, but even more extreme loss of the upper end...
summary(interstat15w5ncde[1,]-interstatde[1,]) # -0.2005 to 0.2564 med 0.02412 <- But this does mean it's reasonable on average

summary(interstat15w9cde[1,]) # 0.4036 to 0.9179 med 0.7824 <- Upper end still being lost :/
summary(interstat15w9cde[1,]-interstatde[1,]) # -0.1900 to 0.2684 med 0.03502

summary(interstat15w9ncde[1,]) # 0.4117 to 0.9297 med 0.7996 <- So upper end still being lost even with the new weights  
summary(interstat15w9ncde[1,]-interstatde[1,]) # -0.1832 to 0.2837 med 0.05179

summary(interstat15w15ncde[1,]) # 0.4191 to 0.9416 med 0.8165 
summary(interstat15w15ncde[1,]-interstatde[1,]) # -0.1709 to 0.3065 med 0.06802
# And do the same using the first difference inter-station correlations:

### Now the same, but where the inter-station correlations are calculated from first difference series:

summary(interstatdef[1,]) # 0.07637 to 0.8754 med 0.4784

summary(interstat25cdef[1,]) # 0.1232 to 0.9907 med 0.4851 
summary(interstat25cdef[1,]-interstatdef[1,]) # -0.3871 to 0.7111 med -0.002209

summary(interstat20w3cdef[1,]) # 0.2582 to 0.8799 med 0.7063 
summary(interstat20w3cdef[1,]-interstatdef[1,]) # -0.1542 to 0.7035 med 0.1959

summary(interstat18w5ncdef[1,]) # 0.2679 to 0.8764 med 0.7052
summary(interstat18w5ncdef[1,]-interstatdef[1,]) # -0.1504 to 0.7015 med 0.1943

summary(interstat18w9cdef[1,]) # 0.2521 to 0.8523 med 0.6782 <- Losing the upper end, but only just 
summary(interstat18w9cdef[1,]-interstatdef[1,]) # -0.1652 to 0.6740 med 0.1678

summary(interstat18w9ncdef[1,]) # 0.2737 to 0.9084 med 0.7418 
summary(interstat18w9ncdef[1,]-interstatdef[1,]) # -0.1355 to 0.7396 med 0.2299

summary(interstat18w15ncdef[1,]) # 0.2724 to 0.8976 med 0.7293 
summary(interstat18w15ncdef[1,]-interstatdef[1,]) # -0.1381 to 0.7266 med 0.2175

summary(interstat15w5ncdef[1,]) # 0.2415 to 0.8214 med 0.6337 <- Even more extreme loss of the upper end...
summary(interstat15w5ncdef[1,]-interstatdef[1,]) # -0.1801 to 0.6274 med 0.1256

summary(interstat15w9cdef[1,]) # 0.2248 to 0.7869 med 0.5971 <- Upper end still being lost pretty drastically :/
summary(interstat15w9cdef[1,]-interstatdef[1,]) # -0.2067 to 0.5905 med 0.08943

summary(interstat15w9ncdef[1,]) # 0.2545 to 0.8671 med 0.6872 <- So upper end not looking bad here  
summary(interstat15w9ncdef[1,]-interstatdef[1,]) # -0.1554 to 0.6829 med 0.1768

summary(interstat15w15ncdef[1,]) # 0.2529 to 0.8481 med 0.6686 
summary(interstat15w15ncdef[1,]-interstatdef[1,]) # -0.1580 to 0.6630 med 0.1583

# Have a look at the plots of interstation correlations:

par(mfrow=c(1,2))
plot(density(interstatde[1,],bw=0.018),ylim=c(0,6),main="Inter-station correlations of observced stations and corrupted station predictions")
lines(density(interstat25cde[1,],bw=0.018),col="red")
lines(density(interstat20w3cde[1,],bw=0.018),col="dark orange")
lines(density(interstat18w5ncde[1,],bw=0.018),col="orange")
lines(density(interstat18w9cde[1,],bw=0.018),col="dark green")
lines(density(interstat18w9ncde[1,],bw=0.018),col="blue")
lines(density(interstat18w15ncde[1,],bw=0.018),col="dark blue")
lines(density(interstat15w5ncde[1,],bw=0.018),col="purple")
lines(density(interstat15w9cde[1,],bw=0.018),col="magenta")
lines(density(interstat15w9ncde[1,],bw=0.018),col="pink") # This one is actually looking OK-ish
lines(density(interstat15w15ncde[1,],bw=0.018),col="brown")
legend(0.35,6,lty=c(1,1,1,1,1,1,1,1,1,1,1),lwd=c(rep(2,11)),col=c("black","red","dark orange","orange","dark green","blue","dark blue", "purple", "magenta","pink","brown"),c("Observations","Release version - corrupted","20 stats - 3 point weighted MA - corrupted","18 stats - 5 point weighted MA - corrupted","18 stats - 9 point weighted MA - corrupted","18 stats - 9 point weighted MA - new weights - corrupted","18 stats - 15 point weighted MA - corrupted","15 stats - 5 point weighted MA - corrupted","15 stats - 9 point weighted MA - corrupted","15 stats - 9 point weighted MA - new weights - corrupted","15 stats - 15 point weighted MA - corrupted"))
plot(density(interstatdef[1,],bw=0.022),ylim=c(0,4.2),main="Inter-station correlations of observced stations and corrupted station predictions \n Where inter-station correlations have been calculated using first differences")
lines(density(interstat25cdef[1,],bw=0.022),col="red")
lines(density(interstat20w3cdef[1,],bw=0.022),col="dark orange")
lines(density(interstat18w5ncdef[1,],bw=0.022),col="orange")
lines(density(interstat18w9cdef[1,],bw=0.022),col="dark green")
lines(density(interstat18w9ncdef[1,],bw=0.022),col="blue")
lines(density(interstat18w15ncdef[1,],bw=0.022),col="dark blue")
lines(density(interstat15w5ncdef[1,],bw=0.022),col="purple")
lines(density(interstat15w9cdef[1,],bw=0.022),col="magenta")
lines(density(interstat15w9ncdef[1,],bw=0.022),col="pink") # This one is actually looking OK-ish
lines(density(interstat15w15ncdef[1,],bw=0.022),col="brown")
legend(0,4.2,lty=c(1,1,1,1,1,1,1,1,1,1,1),lwd=c(rep(2,11)),col=c("black","red","dark orange","orange","dark green","blue","dark blue", "purple", "magenta","pink","brown"),c("Observations","Release version - corrupted","20 stats - 3 point weighted MA - corrupted","18 stats - 5 point weighted MA - corrupted","18 stats - 9 point weighted MA - corrupted","18 stats - 9 point weighted MA - new weights - corrupted","18 stats - 15 point weighted MA - corrupted","15 stats - 5 point weighted MA - corrupted","15 stats - 9 point weighted MA - corrupted","15 stats - 9 point weighted MA - new weights - corrupted","15 stats - 15 point weighted MA - corrupted")) # saved as wyf_fig6

# And look at different plots of predicted minus observed inter-station correlations:

interstatd=t(rbind(statlist1,statlist,interstatde,interstat25cde,interstat20w3cde,interstat18w5ncde,interstat18w9cde,interstat18w9ncde, interstat18w15ncde,interstat15w5ncde,interstat15w9cde,interstat15w9ncde,interstat15w15ncde))

par(mfrow=c(4,1))
plot(interstatd[,1],interstatd[,4]-interstatd[,3],main="Predicted minus observed inter-station correlations - 25 stats- Release version after deseasonalisation - Corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.2,0.35))
abline(h=0)
plot(interstatd[,1],interstatd[,5]-interstatd[,3],main="Predicted minus observed inter-station correlations - 20 stats - 3 point weighted MA after deseasonalisation - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.2,0.35))
abline(h=0)
plot(interstatd[,1],interstatd[,6]-interstatd[,3],main="Predicted minus observed inter-station correlations - 18 stats - 5 point weighted MA after deseasonalisation - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.2,0.35))
abline(h=0)
plot(interstatd[,1],interstatd[,7]-interstatd[,3],main="Predicted minus observed inter-station correlations - 18 stats - 9 point weighted MA after deseasonalisation - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.2,0.35))
abline(h=0) # saved as wyfc_fig7

par(mfrow=c(4,1))
plot(interstatd[,1],interstatd[,4]-interstatd[,3],main="Predicted minus observed inter-station correlations - 25 stats- Release version after deseasonalisation - Corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.2,0.35))
abline(h=0)
plot(interstatd[,1],interstatd[,8]-interstatd[,3],main="Predicted minus observed inter-station correlations - 18 stats - 9 point weighted MA after deseasonalisation - new weights - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.2,0.35))
abline(h=0)
plot(interstatd[,1],interstatd[,9]-interstatd[,3],main="Predicted minus observed inter-station correlations - 18 stats - 15 point weighted MA after deseasonalisation - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.2,0.35))
abline(h=0)
plot(interstatd[,1],interstatd[,10]-interstatd[,3],main="Predicted minus observed inter-station correlations - 15 stats - 5 point weighted MA after deseasonalisation - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.2,0.35))
abline(h=0) # saved as wyfc_fig7a

par(mfrow=c(4,1))
plot(interstatd[,1],interstatd[,4]-interstatd[,3],main="Predicted minus observed inter-station correlations - 25 stats- Release version after deseasonalisation - Corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.2,0.35))
abline(h=0)
plot(interstatd[,1],interstatd[,11]-interstatd[,3],main="Predicted minus observed inter-station correlations - 15 stats - 9 point weighted MA after deseasonalisation - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.2,0.35))
abline(h=0)
plot(interstatd[,1],interstatd[,12]-interstatd[,3],main="Predicted minus observed inter-station correlations - 15 stats - 9 point weighted MA after deseasonalisation - new weights - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.2,0.35))
abline(h=0)
plot(interstatd[,1],interstatd[,13]-interstatd[,3],main="Predicted minus observed inter-station correlations - 15 stats - 15 point weighted MA after deseasonalisation - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.2,0.35))
abline(h=0) # saved as wyf_fig7b

par(mfrow=c(3,1))
plot(interstatd[,1],interstatd[,4]-interstatd[,3],main="Predicted minus observed inter-station correlations - corrupted release version",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.2,0.35))
abline(h=0)
plot(interstatd[,1],interstatd[,7]-interstatd[,3],main="Predicted minus observed inter-station correlations - 18 stats - 9 point weighted MA- corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.2,0.35))
abline(h=0)
plot(interstatd[,1],interstatd[,11]-interstatd[,3],main="Predicted minus observed inter-station correlations - 15 stats - 9 point weighted MA - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.2,0.35))
abline(h=0) # saved as wyfb_fig7 

# Do the same, but now for the inter-station correlations calculated usign first difference series:

interstatdf=t(rbind(statlist1,statlist,interstatdef,interstat25cdef,interstat20w3cdef,interstat18w5ncdef,interstat18w9cdef,interstat18w9ncdef, interstat18w15ncdef,interstat15w5ncdef,interstat15w9cdef,interstat15w9ncdef,interstat15w15ncdef))

par(mfrow=c(4,1))
plot(interstatdf[,1],interstatdf[,4]-interstatdf[,3],main="Predicted minus observed inter-station correlations - 25 stats- Release version after deseasonalisation - Corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.75))
abline(h=0)
plot(interstatdf[,1],interstatdf[,5]-interstatdf[,3],main="Predicted minus observed inter-station correlations - 20 stats - 3 point weighted MA after deseasonalisation - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.75))
abline(h=0)
plot(interstatdf[,1],interstatdf[,6]-interstatdf[,3],main="Predicted minus observed inter-station correlations - 18 stats - 5 point weighted MA after deseasonalisation - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.75))
abline(h=0)
plot(interstatdf[,1],interstatdf[,7]-interstatdf[,3],main="Predicted minus observed inter-station correlations - 18 stats - 9 point weighted MA after deseasonalisation - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.75))
abline(h=0) # saved as wyfc_fig7c

par(mfrow=c(4,1))
plot(interstatdf[,1],interstatdf[,4]-interstatdf[,3],main="Predicted minus observed inter-station correlations - 25 stats- Release version after deseasonalisation - Corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.75))
abline(h=0)
plot(interstatdf[,1],interstatdf[,8]-interstatdf[,3],main="Predicted minus observed inter-station correlations - 18 stats - 9 point weighted MA after deseasonalisation - new weights - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.75))
abline(h=0)
plot(interstatdf[,1],interstatdf[,9]-interstatdf[,3],main="Predicted minus observed inter-station correlations - 18 stats - 15 point weighted MA after deseasonalisation - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.75))
abline(h=0)
plot(interstatdf[,1],interstatdf[,10]-interstatdf[,3],main="Predicted minus observed inter-station correlations - 15 stats - 5 point weighted MA after deseasonalisation - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.75))
abline(h=0) # saved as wyfc_fig7d

par(mfrow=c(4,1))
plot(interstatdf[,1],interstatdf[,4]-interstatdf[,3],main="Predicted minus observed inter-station correlations - 25 stats- Release version after deseasonalisation - Corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.75))
abline(h=0)
plot(interstatdf[,1],interstatdf[,11]-interstatdf[,3],main="Predicted minus observed inter-station correlations - 15 stats - 9 point weighted MA after deseasonalisation - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.75))
abline(h=0)
plot(interstatdf[,1],interstatdf[,12]-interstatdf[,3],main="Predicted minus observed inter-station correlations - 15 stats - 9 point weighted MA after deseasonalisation - new weights - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.75))
abline(h=0)
plot(interstatdf[,1],interstatdf[,13]-interstatdf[,3],main="Predicted minus observed inter-station correlations - 15 stats - 15 point weighted MA after deseasonalisation - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.75))
abline(h=0) # saved as wyfc_fig7e

par(mfrow=c(3,1))
plot(interstatdf[,1],interstatdf[,4]-interstatdf[,3],main="Predicted minus observed inter-station correlations - corrupted release version",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.75))
abline(h=0)
plot(interstatdf[,1],interstatdf[,7]-interstatdf[,3],main="Predicted minus observed inter-station correlations - 18 stats - 9 point weighted MA- corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.75))
abline(h=0)
plot(interstatdf[,1],interstatdf[,11]-interstatdf[,3],main="Predicted minus observed inter-station correlations - 15 stats - 9 point weighted MA - corrupted",xlab="Station",ylab="Pred - obs inter-stat corrs",ylim=c(-0.4,0.75))
abline(h=0) # saved as wyfbfc_fig7 

# Now I want to look at the auto-correlations in the deseasonalised series (this was the whole reason for doing all of this!):

acfdewy=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy25c=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy20w3c=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy18w5nc=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy18w9c=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy18w9nc=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy18w15nc=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy15w5nc=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy15w9c=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy15w9nc=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy15w15nc=as.data.frame(matrix(ncol=75,nrow=26))

for (i in 1:75){
	acfdewy[,i]=acf(deseasont[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy25c[,i]=acf(deseason25c[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy20w3c[,i]=acf(deseason20w3c[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy18w5nc[,i]=acf(deseason18w5nc[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy18w9c[,i]=acf(deseason18w9c[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy18w9nc[,i]=acf(deseason18w9nc[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy18w15nc[,i]=acf(deseason18w15nc[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy15w5nc[,i]=acf(deseason15w5nc[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy15w9c[,i]=acf(deseason15w9c[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy15w9nc[,i]=acf(deseason15w9nc[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy15w15nc[,i]=acf(deseason15w15nc[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
}

# Look at the autocorrelations in the deseasonalised series, not difference series:

par(mfrow=c(5,5))
for (i in 1:25){
	plot(acfdewy[2:26,i],main=paste('Station ',i),xlab="lag",ylab="acf",ylim=c(0,1),pch=19)
	points(acfdewy25c[2:26,i],col="red",pch=3)
	points(acfdewy20w3c[2:26,i],col="dark orange",pch=3)
	points(acfdewy18w5nc[2:26,i],col="orange",pch=3)
	points(acfdewy18w9c[2:26,i],col="dark green",pch=3)
	points(acfdewy18w9nc[2:26,i],col="blue",pch=3)
	points(acfdewy18w15nc[2:26,i],col="dark blue",pch=3)
	points(acfdewy15w5nc[2:26,i],col="purple",pch=3)
	points(acfdewy15w9c[2:26,i],col="magenta",pch=3)
	points(acfdewy15w9nc[2:26,i],col="pink",pch=3)
	points(acfdewy15w15nc[2:26,i],col="brown",pch=3)
} # Saved as wyfc_fig8_125 - Oo - these look pretty good :)

par(mfrow=c(5,5))
for (i in 26:50){
	plot(acfdewy[2:26,i],main=paste('Station ',i),xlab="lag",ylab="acf",ylim=c(0,1),pch=19)
	points(acfdewy25c[2:26,i],col="red",pch=3)
	points(acfdewy20w3c[2:26,i],col="dark orange",pch=3)
	points(acfdewy18w5nc[2:26,i],col="orange",pch=3)
	points(acfdewy18w9c[2:26,i],col="dark green",pch=3)
	points(acfdewy18w9nc[2:26,i],col="blue",pch=3)
	points(acfdewy18w15nc[2:26,i],col="dark blue",pch=3)
	points(acfdewy15w5nc[2:26,i],col="purple",pch=3)
	points(acfdewy15w9c[2:26,i],col="magenta",pch=3)
	points(acfdewy15w9nc[2:26,i],col="pink",pch=3)
	points(acfdewy15w15nc[2:26,i],col="brown",pch=3)
} # Saved as wyfc_fig8_2651

par(mfrow=c(5,5))
for (i in 51:75){
	plot(acfdewy[2:26,i],main=paste('Station ',i),xlab="lag",ylab="acf",ylim=c(0,1),pch=19)
	points(acfdewy25c[2:26,i],col="red",pch=3)
	points(acfdewy20w3c[2:26,i],col="dark orange",pch=3)
	points(acfdewy18w5nc[2:26,i],col="orange",pch=3)
	points(acfdewy18w9c[2:26,i],col="dark green",pch=3)
	points(acfdewy18w9nc[2:26,i],col="blue",pch=3)
	points(acfdewy18w15nc[2:26,i],col="dark blue",pch=3)
	points(acfdewy15w5nc[2:26,i],col="purple",pch=3)
	points(acfdewy15w9c[2:26,i],col="magenta",pch=3)
	points(acfdewy15w9nc[2:26,i],col="pink",pch=3)
	points(acfdewy15w15nc[2:26,i],col="brown",pch=3)
} # Saved as wyfc_fig8_5175

# Could look at summaries of these autocorrelations at different lags and also look at pacfs, but I don't think this is the best use of my time now and I don't think it will be influential in my decision => May come back to this if time before release, but won't do it now

# Want to work out the most highly correlated neighbour for each station - first using the inter-station correlations based on the raw deseasonalised series

highcorrobsd=as.data.frame(matrix(nrow=75,ncol=1))
highcorr25cde=as.data.frame(matrix(nrow=75,ncol=1))
highcorr20w3cde=as.data.frame(matrix(nrow=75,ncol=1))
highcorr18w5ncde=as.data.frame(matrix(nrow=75,ncol=1))
highcorr18w9cde=as.data.frame(matrix(nrow=75,ncol=1))
highcorr18w9ncde=as.data.frame(matrix(nrow=75,ncol=1))
highcorr18w15ncde=as.data.frame(matrix(nrow=75,ncol=1))
highcorr15w5ncde=as.data.frame(matrix(nrow=75,ncol=1))
highcorr15w9cde=as.data.frame(matrix(nrow=75,ncol=1))
highcorr15w9ncde=as.data.frame(matrix(nrow=75,ncol=1))
highcorr15w15ncde=as.data.frame(matrix(nrow=75,ncol=1))

deseasontc1=deseasontc # 75 rows and 75 columns
deseason25cor1=deseason25cor
deseason20w3cor1=deseason20w3cor
deseason18w5ncor1=deseason18w5ncor
deseason18w9cor1=deseason18w9cor
deseason18w9ncor1=deseason18w9ncor
deseason18w15ncor1=deseason18w15ncor
deseason15w5ncor1=deseason15w5ncor
deseason15w9cor1=deseason15w9cor
deseason15w9ncor1=deseason15w9ncor
deseason15w15ncor1=deseason15w15ncor

for (i in 1:75){ # Putting NAs on the diagonal so that a station isn't shown as being most highly correlated with itself!
	deseasontc1[i,i]=NA
	deseason25cor1[i,i]=NA
	deseason20w3cor1[i,i]=NA
	deseason18w5ncor1[i,i]=NA
	deseason18w9cor1[i,i]=NA
	deseason18w9ncor1[i,i]=NA
	deseason18w15ncor1[i,i]=NA
	deseason15w5ncor1[i,i]=NA
	deseason15w9cor1[i,i]=NA
	deseason15w9ncor1[i,i]=NA
	deseason15w15ncor1[i,i]=NA
}

for (i in 1:75){
	highcorrobsd[i,1]=which.max(deseasontc1[,i])  
	highcorr25cde[i,1]=which.max(deseason25cor1[,i])  
	highcorr20w3cde[i,1]=which.max(deseason20w3cor1[,i])  
	highcorr18w5ncde[i,1]=which.max(deseason18w5ncor1[,i])  
	highcorr18w9cde[i,1]=which.max(deseason18w9cor1[,i])  
	highcorr18w9ncde[i,1]=which.max(deseason18w9ncor1[,i])  
	highcorr18w15ncde[i,1]=which.max(deseason18w15ncor1[,i])  
	highcorr15w5ncde[i,1]=which.max(deseason15w5ncor1[,i])  
	highcorr15w9cde[i,1]=which.max(deseason15w9cor1[,i])  
	highcorr15w9ncde[i,1]=which.max(deseason15w9ncor1[,i])  
	highcorr15w15ncde[i,1]=which.max(deseason15w15ncor1[,i])  
} # Storing the most highly correlated neighbour for each station

# Now want to work out difference series between the stations and their nearest neighbours (and store these):

diffobsde=as.data.frame(matrix(nrow=15340,ncol=75))
diffobsde25c=as.data.frame(matrix(nrow=15340,ncol=75))
diffobsde20w3c=as.data.frame(matrix(nrow=15340,ncol=75))
diffobsde18w5nc=as.data.frame(matrix(nrow=15340,ncol=75))
diffobsde18w9c=as.data.frame(matrix(nrow=15340,ncol=75))
diffobsde18w9nc=as.data.frame(matrix(nrow=15340,ncol=75))
diffobsde18w15nc=as.data.frame(matrix(nrow=15340,ncol=75))
diffobsde15w5nc=as.data.frame(matrix(nrow=15340,ncol=75))
diffobsde15w9c=as.data.frame(matrix(nrow=15340,ncol=75))
diffobsde15w9nc=as.data.frame(matrix(nrow=15340,ncol=75))
diffobsde15w15nc=as.data.frame(matrix(nrow=15340,ncol=75))

for (i in 1:75){ # Differencing wrt most highly correlated neighbour in that world
	diffobsde[,i]=deseasont[,i]-deseasont[,(highcorrobsd[i,1])]
	diffobsde25c[,i]=deseason25c[,i]-deseason25c[,(highcorr25cde[i,1])]
	diffobsde20w3c[,i]=deseason20w3c[,i]-deseason20w3c[,(highcorr20w3cde[i,1])]
	diffobsde18w5nc[,i]=deseason18w5nc[,i]-deseason18w5nc[,(highcorr18w5ncde[i,1])]
	diffobsde18w9c[,i]=deseason18w9c[,i]-deseason18w9c[,(highcorr18w9cde[i,1])]
	diffobsde18w9nc[,i]=deseason18w9nc[,i]-deseason18w9nc[,(highcorr18w9ncde[i,1])]
	diffobsde18w15nc[,i]=deseason18w15nc[,i]-deseason18w15nc[,(highcorr18w15ncde[i,1])]
	diffobsde15w5nc[,i]=deseason15w5nc[,i]-deseason15w5nc[,(highcorr15w5ncde[i,1])]
	diffobsde15w9c[,i]=deseason15w9c[,i]-deseason15w9c[,(highcorr15w9cde[i,1])]
	diffobsde15w9nc[,i]=deseason15w9nc[,i]-deseason15w9nc[,(highcorr15w9ncde[i,1])]
	diffobsde15w15nc[,i]=deseason15w15nc[,i]-deseason15w15nc[,(highcorr15w15ncde[i,1])]
}

# Now do the same as above, but where the inter-station correlations are calculated using first difference series:

highcorrobsdf=as.data.frame(matrix(nrow=75,ncol=1))
highcorr25cdef=as.data.frame(matrix(nrow=75,ncol=1))
highcorr20w3cdef=as.data.frame(matrix(nrow=75,ncol=1))
highcorr18w5ncdef=as.data.frame(matrix(nrow=75,ncol=1))
highcorr18w9cdef=as.data.frame(matrix(nrow=75,ncol=1))
highcorr18w9ncdef=as.data.frame(matrix(nrow=75,ncol=1))
highcorr18w15ncdef=as.data.frame(matrix(nrow=75,ncol=1))
highcorr15w5ncdef=as.data.frame(matrix(nrow=75,ncol=1))
highcorr15w9cdef=as.data.frame(matrix(nrow=75,ncol=1))
highcorr15w9ncdef=as.data.frame(matrix(nrow=75,ncol=1))
highcorr15w15ncdef=as.data.frame(matrix(nrow=75,ncol=1))

deseasontcf1=deseasontcf # 75 rows and 75 columns
deseason25cfcor1=deseason25cfcor
deseason20w3cfcor1=deseason20w3cfcor
deseason18w5ncfcor1=deseason18w5ncfcor
deseason18w9cfcor1=deseason18w9cfcor
deseason18w9ncfcor1=deseason18w9ncfcor
deseason18w15ncfcor1=deseason18w15ncfcor
deseason15w5ncfcor1=deseason15w5ncfcor
deseason15w9cfcor1=deseason15w9cfcor
deseason15w9ncfcor1=deseason15w9ncfcor
deseason15w15ncfcor1=deseason15w15ncfcor

for (i in 1:75){ # Putting NAs on the diagonal so that a station isn't shown as being most highly correlated with itself!
	deseasontcf1[i,i]=NA
	deseason25cfcor1[i,i]=NA
	deseason20w3cfcor1[i,i]=NA
	deseason18w5ncfcor1[i,i]=NA
	deseason18w9cfcor1[i,i]=NA
	deseason18w9ncfcor1[i,i]=NA
	deseason18w15ncfcor1[i,i]=NA
	deseason15w5ncfcor1[i,i]=NA
	deseason15w9cfcor1[i,i]=NA
	deseason15w9ncfcor1[i,i]=NA
	deseason15w15ncfcor1[i,i]=NA
}

for (i in 1:75){
	highcorrobsdf[i,1]=which.max(deseasontcf1[,i])  
	highcorr25cdef[i,1]=which.max(deseason25cfcor1[,i])  
	highcorr20w3cdef[i,1]=which.max(deseason20w3cfcor1[,i])  
	highcorr18w5ncdef[i,1]=which.max(deseason18w5ncfcor1[,i])  
	highcorr18w9cdef[i,1]=which.max(deseason18w9cfcor1[,i])  
	highcorr18w9ncdef[i,1]=which.max(deseason18w9ncfcor1[,i])  
	highcorr18w15ncdef[i,1]=which.max(deseason18w15ncfcor1[,i])  
	highcorr15w5ncdef[i,1]=which.max(deseason15w5ncfcor1[,i])  
	highcorr15w9cdef[i,1]=which.max(deseason15w9cfcor1[,i])  
	highcorr15w9ncdef[i,1]=which.max(deseason15w9ncfcor1[,i])  
	highcorr15w15ncdef[i,1]=which.max(deseason15w15ncfcor1[,i])  
} # Storing the most highly correlated neighbour for each station

# Now want to work out difference series between the stations and their nearest neighbours (and store these) - STILL WANT THESE TO BE CALCULATED FROM JUST THE DESEASONALISED SERIES, NOT THE FIRST DIFFERENCES OF THE DESEASONALISED SERIES:

diffobsdef=as.data.frame(matrix(nrow=15340,ncol=75))
diffobsde25cf=as.data.frame(matrix(nrow=15340,ncol=75))
diffobsde20w3cf=as.data.frame(matrix(nrow=15340,ncol=75))
diffobsde18w5ncf=as.data.frame(matrix(nrow=15340,ncol=75))
diffobsde18w9cf=as.data.frame(matrix(nrow=15340,ncol=75))
diffobsde18w9ncf=as.data.frame(matrix(nrow=15340,ncol=75))
diffobsde18w15ncf=as.data.frame(matrix(nrow=15340,ncol=75))
diffobsde15w5ncf=as.data.frame(matrix(nrow=15340,ncol=75))
diffobsde15w9cf=as.data.frame(matrix(nrow=15340,ncol=75))
diffobsde15w9ncf=as.data.frame(matrix(nrow=15340,ncol=75))
diffobsde15w15ncf=as.data.frame(matrix(nrow=15340,ncol=75))

for (i in 1:75){ # Differencing wrt most highly correlated neighbour in that world
	diffobsdef[,i]=deseasont[,i]-deseasont[,(highcorrobsdf[i,1])]
	diffobsde25cf[,i]=deseason25c[,i]-deseason25c[,(highcorr25cdef[i,1])]
	diffobsde20w3cf[,i]=deseason20w3c[,i]-deseason20w3c[,(highcorr20w3cdef[i,1])]
	diffobsde18w5ncf[,i]=deseason18w5nc[,i]-deseason18w5nc[,(highcorr18w5ncdef[i,1])]
	diffobsde18w9cf[,i]=deseason18w9c[,i]-deseason18w9c[,(highcorr18w9cdef[i,1])]
	diffobsde18w9ncf[,i]=deseason18w9nc[,i]-deseason18w9nc[,(highcorr18w9ncdef[i,1])]
	diffobsde18w15ncf[,i]=deseason18w15nc[,i]-deseason18w15nc[,(highcorr18w15ncdef[i,1])]
	diffobsde15w5ncf[,i]=deseason15w5nc[,i]-deseason15w5nc[,(highcorr15w5ncdef[i,1])]
	diffobsde15w9cf[,i]=deseason15w9c[,i]-deseason15w9c[,(highcorr15w9cdef[i,1])]
	diffobsde15w9ncf[,i]=deseason15w9nc[,i]-deseason15w9nc[,(highcorr15w9ncdef[i,1])]
	diffobsde15w15ncf[,i]=deseason15w15nc[,i]-deseason15w15nc[,(highcorr15w15ncdef[i,1])]
}

# Look at the standard deviations in the difference series:

sdwy=as.data.frame(matrix(nrow=75,ncol=11))

for (i in 1:75){
	sdwy[i,1]=sd(diffobsde[,i],na.rm=TRUE)
	sdwy[i,2]=sd(diffobsde25c[,i],na.rm=TRUE)
	sdwy[i,3]=sd(diffobsde20w3c[,i],na.rm=TRUE)
	sdwy[i,4]=sd(diffobsde18w5nc[,i],na.rm=TRUE)
	sdwy[i,5]=sd(diffobsde18w9c[,i],na.rm=TRUE)
	sdwy[i,6]=sd(diffobsde18w9nc[,i],na.rm=TRUE)
	sdwy[i,7]=sd(diffobsde18w15nc[,i],na.rm=TRUE)
	sdwy[i,8]=sd(diffobsde15w5nc[,i],na.rm=TRUE)
	sdwy[i,9]=sd(diffobsde15w9c[,i],na.rm=TRUE)
	sdwy[i,10]=sd(diffobsde15w9nc[,i],na.rm=TRUE)
	sdwy[i,11]=sd(diffobsde15w15nc[,i],na.rm=TRUE)
}

# Look at plots of the standard deviations in the difference series:

par(mfrow=c(3,4))
plot(sdwy[,1],ylim=c(0,4.5),main="25 stations - Release version - corrupted",pch=19,xlab="Station",ylab="Standard Deviation")
points(sdwy[,2],col="red",pch=19)
plot(sdwy[,1],ylim=c(0,4.5),main="20 stations - 3 point weighted MA - corrupted",pch=19,xlab="Station",ylab="Standard Deviation")
points(sdwy[,3],col="red",pch=19)
plot(sdwy[,1],ylim=c(0,4.5),main="18 stations - 5 point weighted MA - corrupted",pch=19,xlab="Station",ylab="Standard Deviation")
points(sdwy[,4],col="red",pch=19)
plot(sdwy[,1],ylim=c(0,4.5),main="18 stations - 9 point weighted MA - corrupted",pch=19,xlab="Station",ylab="Standard Deviation")
points(sdwy[,5],col="red",pch=19)
plot(sdwy[,1],ylim=c(0,4.5),main="18 stations - 9 point weighted MA - new weights - corrupted", pch=19,xlab="Station", ylab="Standard Deviation")
points(sdwy[,6],col="red",pch=19)
plot(sdwy[,1],ylim=c(0,4.5),main="18 stations - 15 point weighted MA",pch=19,xlab="Station",ylab="Standard Deviation")
points(sdwy[,7],col="red",pch=19)
plot(sdwy[,1],ylim=c(0,4.5),main="15 stations - 5 point weighted MA",pch=19,xlab="Station",ylab="Standard Deviation")
points(sdwy[,8],col="red",pch=19)
plot(sdwy[,1],ylim=c(0,4.5),main="15 stations - 9 point weighted MA",pch=19,xlab="Station",ylab="Standard Deviation")
points(sdwy[,9],col="red",pch=19)
plot(sdwy[,1],ylim=c(0,4.5),main="15 stations - 9 point weighted MA - new weights",pch=19,xlab="Station",ylab="Standard Deviation")
points(sdwy[,10],col="red",pch=19)
plot(sdwy[,1],ylim=c(0,4.5),main="15 stations - 15 point weighted MA",pch=19,xlab="Station",ylab="Standard Deviation")
points(sdwy[,11],col="red",pch=19) # saved as wyfc_fig9 

# Look at the standard deviations in the difference series (when the most highly correlated stations were selected based on first difference series):

sdwyf=as.data.frame(matrix(nrow=75,ncol=11))

for (i in 1:75){
	sdwyf[i,1]=sd(diffobsdef[,i],na.rm=TRUE)
	sdwyf[i,2]=sd(diffobsde25cf[,i],na.rm=TRUE)
	sdwyf[i,3]=sd(diffobsde20w3cf[,i],na.rm=TRUE)
	sdwyf[i,4]=sd(diffobsde18w5ncf[,i],na.rm=TRUE)
	sdwyf[i,5]=sd(diffobsde18w9cf[,i],na.rm=TRUE)
	sdwyf[i,6]=sd(diffobsde18w9ncf[,i],na.rm=TRUE)
	sdwyf[i,7]=sd(diffobsde18w15ncf[,i],na.rm=TRUE)
	sdwyf[i,8]=sd(diffobsde15w5ncf[,i],na.rm=TRUE)
	sdwyf[i,9]=sd(diffobsde15w9cf[,i],na.rm=TRUE)
	sdwyf[i,10]=sd(diffobsde15w9ncf[,i],na.rm=TRUE)
	sdwyf[i,11]=sd(diffobsde15w15ncf[,i],na.rm=TRUE)
}

# Look at plots of the standard deviations in the difference series:

par(mfrow=c(3,4))
plot(sdwyf[,1],ylim=c(0,4.5),main="25 stations - Release version - corrupted",pch=19,xlab="Station",ylab="Standard Deviation")
points(sdwyf[,2],col="red",pch=19)
plot(sdwyf[,1],ylim=c(0,4.5),main="20 stations - 3 point weighted MA - corrupted",pch=19,xlab="Station",ylab="Standard Deviation")
points(sdwyf[,3],col="red",pch=19)
plot(sdwyf[,1],ylim=c(0,4.5),main="18 stations - 5 point weighted MA - corrupted",pch=19,xlab="Station",ylab="Standard Deviation")
points(sdwyf[,4],col="red",pch=19)
plot(sdwyf[,1],ylim=c(0,4.5),main="18 stations - 9 point weighted MA - corrupted",pch=19,xlab="Station",ylab="Standard Deviation")
points(sdwyf[,5],col="red",pch=19)
plot(sdwyf[,1],ylim=c(0,4.5),main="18 stations - 9 point weighted MA - new weights - corrupted", pch=19,xlab="Station", ylab="Standard Deviation")
points(sdwyf[,6],col="red",pch=19)
plot(sdwyf[,1],ylim=c(0,4.5),main="18 stations - 15 point weighted MA",pch=19,xlab="Station",ylab="Standard Deviation")
points(sdwyf[,7],col="red",pch=19)
plot(sdwyf[,1],ylim=c(0,4.5),main="15 stations - 5 point weighted MA",pch=19,xlab="Station",ylab="Standard Deviation")
points(sdwyf[,8],col="red",pch=19)
plot(sdwyf[,1],ylim=c(0,4.5),main="15 stations - 9 point weighted MA",pch=19,xlab="Station",ylab="Standard Deviation")
points(sdwyf[,9],col="red",pch=19)
plot(sdwyf[,1],ylim=c(0,4.5),main="15 stations - 9 point weighted MA - new weights",pch=19,xlab="Station",ylab="Standard Deviation")
points(sdwyf[,10],col="red",pch=19)
plot(sdwyf[,1],ylim=c(0,4.5),main="15 stations - 15 point weighted MA",pch=19,xlab="Station",ylab="Standard Deviation")
points(sdwyf[,11],col="red",pch=19) # saved as wyf_fig9a

# Look at the densities of the standard deviations in the difference series:

par(mfrow=c(1,2))
plot(density(sdwy[,1],bw=0.15),main="Density of standard deviations in difference series",xlim=c(0,3.9),ylim=c(0,2.6))
lines(density(sdwy[,2],bw=0.15),col="red")
lines(density(sdwy[,3],bw=0.15),col="dark orange")
lines(density(sdwy[,4],bw=0.15),col="orange")
lines(density(sdwy[,5],bw=0.15),col="dark green")
lines(density(sdwy[,6],bw=0.15),col="blue")
lines(density(sdwy[,7],bw=0.15),col="dark blue")
lines(density(sdwy[,8],bw=0.15),col="purple")
lines(density(sdwy[,9],bw=0.15),col="magenta")
lines(density(sdwy[,10],bw=0.15),col="pink")
lines(density(sdwy[,11],bw=0.15),col="brown")
legend(0,2.6,lty=c(1,1,1,1,1,1,1,1,1,1,1),lwd=c(rep(2,11)),col=c("black","red","dark orange","orange","dark green","blue","dark blue", "purple", "magenta","pink","brown"),c("Observations","Release version - corrupted","20 stats - 3 point weighted MA - corrupted","18 stats - 5 point weighted MA - corrupted","18 stats - 9 point weighted MA - corrupted","18 stats - 9 point weighted MA - new weights - corrupted","18 stats - 15 point weighted MA - corrupted","15 stats - 5 point weighted MA - corrupted","15 stats - 9 point weighted MA - corrupted","15 stats - 9 point weighted MA - new weights - corrupted","15 stats - 15 point weighted MA - corrupted"))
plot(density((sdwyf[,1]),bw=0.15),main="Density of standard deviations in difference series \n when most highly correlated neighbour was selected using first differences",xlim=c(0,3.9),ylim=c(0,2.6))
lines(density(sdwyf[,2],bw=0.15),col="red")
lines(density(sdwyf[,3],bw=0.15),col="dark orange")
lines(density(sdwyf[,4],bw=0.15),col="orange")
lines(density(sdwyf[,5],bw=0.15),col="dark green")
lines(density(sdwyf[,6],bw=0.15),col="blue")
lines(density(sdwyf[,7],bw=0.15),col="dark blue")
lines(density(sdwyf[,8],bw=0.15),col="purple")
lines(density(sdwyf[,9],bw=0.15),col="magenta")
lines(density(sdwyf[,10],bw=0.15),col="pink")
lines(density(sdwyf[,11],bw=0.15),col="brown")
legend(0,2.6,lty=c(1,1,1,1,1,1,1,1,1,1,1),lwd=c(rep(2,11)),col=c("black","red","dark orange","orange","dark green","blue","dark blue", "purple", "magenta","pink","brown"),c("Observations","Release version - corrupted","20 stats - 3 point weighted MA - corrupted","18 stats - 5 point weighted MA - corrupted","18 stats - 9 point weighted MA - corrupted","18 stats - 9 point weighted MA - new weights - corrupted","18 stats - 15 point weighted MA - corrupted","15 stats - 5 point weighted MA - corrupted","15 stats - 9 point weighted MA - corrupted","15 stats - 9 point weighted MA - new weights - corrupted","15 stats - 15 point weighted MA - corrupted")) # saved as wyfc_fig9b

# Look at the stat by stat difference series (just for stats 1 to 25 to save me having TOO many plots) => can always come back adn do the others for the smooth(s) I decide upon

par(mfrow=c(5,5))
for (i in 1:25){
	plot(diffobsde[,i],xlab="Time",ylab="Diff (deg C)",main=paste('Station',i,'minus',highcorrobsd[i,1],'observations'),ylim=c(-20,20))
} # saved as wyfc_fig10obs

par(mfrow=c(5,5))
for (i in 1:25){
	plot(diffobsde25c[,i],xlab="Time",ylab="Diff (deg C)",main=paste('Station',i,'minus',highcorr25cde[i,1],' - 25 stats'),ylim=c(-20,20))
} # saved as wyfc_fig10_25c

par(mfrow=c(5,5))
for (i in 1:25){
	plot(diffobsde20w3c[,i],xlab="Time",ylab="Diff (deg C)",main=paste('Station',i,'minus',highcorr20w3cde[i,1],' - 20 stats - w3'),ylim=c(-20,20))
} # saved as wyfc_fig10_20w3c

par(mfrow=c(5,5))
for (i in 1:25){
	plot(diffobsde18w5nc[,i],xlab="Time",ylab="Diff (deg C)",main=paste('Station',i,'minus',highcorr15w5ncde[i,1],' - 18 stats - w5'),ylim=c(-20,20))
} # saved as wyfc_fig10_18w5nc

par(mfrow=c(5,5))
for (i in 1:25){
	plot(diffobsde18w9c[,i],xlab="Time",ylab="Diff (deg C)",main=paste('Station',i,'minus',highcorr18w9cde[i,1],' - 18 stats - w9'),ylim=c(-20,20))
} # saved as wyfc_fig10_18w9c

par(mfrow=c(5,5))
for (i in 1:25){
	plot(diffobsde18w9nc[,i],xlab="Time",ylab="Diff (deg C)",main=paste('Station',i,'minus',highcorr18w9ncde[i,1],' - 18 stats - w9n'),ylim=c(-20,20))
} # saved as wyfc_fig10_18w9nc

par(mfrow=c(5,5))
for (i in 1:25){
	plot(diffobsde18w15nc[,i],xlab="Time",ylab="Diff (deg C)",main=paste('Station',i,'minus',highcorr18w15ncde[i,1],' - 18 stats - w15'),ylim=c(-20,20))
} # saved as wyfc_fig10_18w15n

par(mfrow=c(5,5))
for (i in 1:25){
	plot(diffobsde15w5nc[,i],xlab="Time",ylab="Diff (deg C)",main=paste('Station',i,'minus',highcorr15w5ncde[i,1],' - 15 stats - w5n'),ylim=c(-20,20))
} # saved as wyfc_fig10_w5nc - Now is when the REALLy big differences start to appear

par(mfrow=c(5,5))
for (i in 1:25){
	plot(diffobsde15w9c[,i],xlab="Time",ylab="Diff (deg C)",main=paste('Station',i,'minus',highcorr15w9cde[i,1],' - 15 stats - w9'),ylim=c(-20,20))
} # saved as wyfc_fig10_15w9c

par(mfrow=c(5,5))
for (i in 26:50){
	plot(diffobsde15w9c[,i],xlab="Time",ylab="Diff (deg C)",main=paste('Station',i,'minus',highcorr15w9cde[i,1],' - 15 stats - w9'),ylim=c(-20,20))
} # saved as wyfc_fig10_15w9c_2650

par(mfrow=c(5,5))
for (i in 51:75){
	plot(diffobsde15w9c[,i],xlab="Time",ylab="Diff (deg C)",main=paste('Station',i,'minus',highcorr15w9cde[i,1],' - 15 stats - w9'),ylim=c(-20,20))
} # saved as wyfc_fig10_15w9c_5175

par(mfrow=c(5,5))
for (i in 1:25){
	plot(diffobsde15w9nc[,i],xlab="Time",ylab="Diff (deg C)",main=paste('Station',i,'minus',highcorr15w9ncde[i,1],' - 15 stats - w9n'),ylim=c(-20,20))
} # saved as wyfc_fig10_15w9nc

par(mfrow=c(5,5))
for (i in 1:25){
	plot(diffobsde15w15nc[,i],xlab="Time",ylab="Diff (deg C)",main=paste('Station',i,'minus',highcorr15w15ncde[i,1],' - 15 stats - w15'),ylim=c(-20,20))
} # saved as wyfc_fig10_15w15nc

# AND exactly the same as above, but where the stations have been chosen using first difference series:

par(mfrow=c(5,5))
for (i in 1:25){
	plot(diffobsdef[,i],xlab="Time",ylab="Diff (deg C)",main=paste('Station',i,'minus',highcorrobsdf[i,1],'observations'),ylim=c(-20,20))
} # saved as wyfc_fig10_obsf

par(mfrow=c(5,5))
for (i in 1:25){
	plot(diffobsde25cf[,i],xlab="Time",ylab="Diff (deg C)",main=paste('Station',i,'minus',highcorr25cdef[i,1],' - 25 stats'),ylim=c(-20,20))
} # saved as wyfc_fig10_25cf

par(mfrow=c(5,5))
for (i in 1:25){
	plot(diffobsde20w3cf[,i],xlab="Time",ylab="Diff (deg C)",main=paste('Station',i,'minus',highcorr20w3cdef[i,1],' - 20 stats - w3'),ylim=c(-20,20))
} # saved as wyfc_fig10_20w3cf

par(mfrow=c(5,5))
for (i in 1:25){
	plot(diffobsde18w5ncf[,i],xlab="Time",ylab="Diff (deg C)",main=paste('Station',i,'minus',highcorr15w5ncdef[i,1],' - 18 stats - w5'),ylim=c(-20,20))
} # saved as wyfc_fig10_18w5ncf

par(mfrow=c(5,5))
for (i in 1:25){
	plot(diffobsde18w9cf[,i],xlab="Time",ylab="Diff (deg C)",main=paste('Station',i,'minus',highcorr18w9cdef[i,1],' - 18 stats - w9'),ylim=c(-20,20))
} # saved as wyfc_fig10_18w9cf

par(mfrow=c(5,5))
for (i in 1:25){
	plot(diffobsde18w9ncf[,i],xlab="Time",ylab="Diff (deg C)",main=paste('Station',i,'minus',highcorr18w9ncdef[i,1],' - 18 stats - w9n'),ylim=c(-20,20))
} # saved as wyfc_fig10_18w9ncf

par(mfrow=c(5,5))
for (i in 1:25){
	plot(diffobsde18w15ncf[,i],xlab="Time",ylab="Diff (deg C)",main=paste('Station',i,'minus',highcorr18w15ncdef[i,1],' - 18 stats - w15'),ylim=c(-20,20))
} # saved as wyfc_fig10_18w15nf

par(mfrow=c(5,5))
for (i in 1:25){
	plot(diffobsde15w5ncf[,i],xlab="Time",ylab="Diff (deg C)",main=paste('Station',i,'minus',highcorr15w5ncdef[i,1],' - 15 stats - w5n'),ylim=c(-20,20))
} # saved as wyfc_fig10_15w5ncf - Now is when the REALLy big differences start to appear

par(mfrow=c(5,5))
for (i in 1:25){
	plot(diffobsde15w9cf[,i],xlab="Time",ylab="Diff (deg C)",main=paste('Station',i,'minus',highcorr15w9cdef[i,1],' - 15 stats - w9'),ylim=c(-20,20))
} # saved as wyfc_fig10_15w9cf

par(mfrow=c(5,5))
for (i in 1:25){
	plot(diffobsde15w9ncf[,i],xlab="Time",ylab="Diff (deg C)",main=paste('Station',i,'minus',highcorr15w9ncdef[i,1],' - 15 stats - w9n'),ylim=c(-20,20))
} # saved as wyfc_fig10_15w9ncf

par(mfrow=c(5,5))
for (i in 1:25){
	plot(diffobsde15w15ncf[,i],xlab="Time",ylab="Diff (deg C)",main=paste('Station',i,'minus',highcorr15w15ncdef[i,1],' - 15 stats - w15'),ylim=c(-20,20))
} # saved as wyfc_fig10_15w15ncf

# Now I want to work out the autocorrelations in the deseasonalised difference series:

acfdewydiff=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy25cdiff=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy20w3cdiff=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy18w5ncdiff=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy18w9cdiff=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy18w9ncdiff=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy18w15ncdiff=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy15w5ncdiff=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy15w9cdiff=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy15w9ncdiff=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy15w15ncdiff=as.data.frame(matrix(ncol=75,nrow=26))

for (i in 1:75){
	acfdewydiff[,i]=acf(diffobsde[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy25cdiff[,i]=acf(diffobsde25c[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy20w3cdiff[,i]=acf(diffobsde20w3c[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy18w5ncdiff[,i]=acf(diffobsde18w5nc[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy18w9cdiff[,i]=acf(diffobsde18w9c[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy18w9ncdiff[,i]=acf(diffobsde18w9nc[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy18w15ncdiff[,i]=acf(diffobsde18w15nc[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy15w5ncdiff[,i]=acf(diffobsde15w5nc[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy15w9cdiff[,i]=acf(diffobsde15w9c[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy15w9ncdiff[,i]=acf(diffobsde15w9nc[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy15w15ncdiff[,i]=acf(diffobsde15w15nc[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
}

acfdewydifff=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy25cdifff=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy20w3cdifff=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy18w5ncdifff=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy18w9cdifff=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy18w9ncdifff=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy18w15ncdifff=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy15w5ncdifff=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy15w9cdifff=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy15w9ncdifff=as.data.frame(matrix(ncol=75,nrow=26))
acfdewy15w15ncdifff=as.data.frame(matrix(ncol=75,nrow=26))

for (i in 1:75){
	acfdewydifff[,i]=acf(diffobsdef[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy25cdifff[,i]=acf(diffobsde25cf[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy20w3cdifff[,i]=acf(diffobsde20w3cf[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy18w5ncdifff[,i]=acf(diffobsde18w5ncf[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy18w9cdifff[,i]=acf(diffobsde18w9cf[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy18w9ncdifff[,i]=acf(diffobsde18w9ncf[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy18w15ncdifff[,i]=acf(diffobsde18w15ncf[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy15w5ncdifff[,i]=acf(diffobsde15w5ncf[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy15w9cdifff[,i]=acf(diffobsde15w9cf[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy15w9ncdifff[,i]=acf(diffobsde15w9ncf[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
	acfdewy15w15ncdifff[,i]=acf(diffobsde15w15ncf[,i],lag=25,plot=FALSE,na.action=na.pass)$acf
}

# Now look at the autocorrelation plots for the deseasonalised difference series:

par(mfrow=c(5,5))
for (i in 1:25){
	plot(acfdewydiff[2:26,i],main=paste('Station ',i),xlab="lag",ylab="acf",ylim=c(0,1),pch=19)
	points(acfdewy25cdiff[2:26,i],col="red",pch=3)
	points(acfdewy20w3cdiff[2:26,i],col="dark orange",pch=3)
	points(acfdewy18w5ncdiff[2:26,i],col="orange",pch=3)
	points(acfdewy18w9cdiff[2:26,i],col="dark green",pch=3)
	points(acfdewy18w9ncdiff[2:26,i],col="blue",pch=3)
	points(acfdewy18w15ncdiff[2:26,i],col="dark blue",pch=3)
	points(acfdewy15w5ncdiff[2:26,i],col="purple",pch=3)
	points(acfdewy15w9cdiff[2:26,i],col="magenta",pch=3)
	points(acfdewy15w9ncdiff[2:26,i],col="pink",pch=3)
	points(acfdewy15w15ncdiff[2:26,i],col="brown",pch=3)
} # saved as wyfc_fig11_125

par(mfrow=c(5,5))
for (i in 26:50){
	plot(acfdewydiff[2:26,i],main=paste('Station ',i),xlab="lag",ylab="acf",ylim=c(0,1),pch=19)
	points(acfdewy25cdiff[2:26,i],col="red",pch=3)
	points(acfdewy20w3cdiff[2:26,i],col="dark orange",pch=3)
	points(acfdewy18w5ncdiff[2:26,i],col="orange",pch=3)
	points(acfdewy18w9cdiff[2:26,i],col="dark green",pch=3)
	points(acfdewy18w9ncdiff[2:26,i],col="blue",pch=3)
	points(acfdewy18w15ncdiff[2:26,i],col="dark blue",pch=3)
	points(acfdewy15w5ncdiff[2:26,i],col="purple",pch=3)
	points(acfdewy15w9cdiff[2:26,i],col="magenta",pch=3)
	points(acfdewy15w9ncdiff[2:26,i],col="pink",pch=3)
	points(acfdewy15w15ncdiff[2:26,i],col="brown",pch=3)
} # saved as wyfc_fig11_2650

par(mfrow=c(5,5))
for (i in 51:75){
	plot(acfdewydiff[2:26,i],main=paste('Station ',i),xlab="lag",ylab="acf",ylim=c(0,1),pch=19)
	points(acfdewy25cdiff[2:26,i],col="red",pch=3)
	points(acfdewy20w3cdiff[2:26,i],col="dark orange",pch=3)
	points(acfdewy18w5ncdiff[2:26,i],col="orange",pch=3)
	points(acfdewy18w9cdiff[2:26,i],col="dark green",pch=3)
	points(acfdewy18w9ncdiff[2:26,i],col="blue",pch=3)
	points(acfdewy18w15ncdiff[2:26,i],col="dark blue",pch=3)
	points(acfdewy15w5ncdiff[2:26,i],col="purple",pch=3)
	points(acfdewy15w9cdiff[2:26,i],col="magenta",pch=3)
	points(acfdewy15w9ncdiff[2:26,i],col="pink",pch=3)
	points(acfdewy15w15ncdiff[2:26,i],col="brown",pch=3)
} # saved as wyfc_fig11_5175

# Create these plots for the difference series that have been made by differencing with the most highly correlated neighbour selected using first difference series:

par(mfrow=c(5,5))
for (i in 1:25){
	plot(acfdewydifff[2:26,i],main=paste('Station ',i),xlab="lag",ylab="acf",ylim=c(0,1),pch=19)
	points(acfdewy25cdifff[2:26,i],col="red",pch=3)
	points(acfdewy20w3cdifff[2:26,i],col="dark orange",pch=3)
	points(acfdewy18w5ncdifff[2:26,i],col="orange",pch=3)
	points(acfdewy18w9cdifff[2:26,i],col="dark green",pch=3)
	points(acfdewy18w9ncdifff[2:26,i],col="blue",pch=3)
	points(acfdewy18w15ncdifff[2:26,i],col="dark blue",pch=3)
	points(acfdewy15w5ncdifff[2:26,i],col="purple",pch=3)
	points(acfdewy15w9cdifff[2:26,i],col="magenta",pch=3)
	points(acfdewy15w9ncdifff[2:26,i],col="pink",pch=3)
	points(acfdewy15w15ncdifff[2:26,i],col="brown",pch=3)
} # saved as wyffc_fig11_125

par(mfrow=c(5,5))
for (i in 26:50){
	plot(acfdewydifff[2:26,i],main=paste('Station ',i),xlab="lag",ylab="acf",ylim=c(0,1),pch=19)
	points(acfdewy25cdifff[2:26,i],col="red",pch=3)
	points(acfdewy20w3cdifff[2:26,i],col="dark orange",pch=3)
	points(acfdewy18w5ncdifff[2:26,i],col="orange",pch=3)
	points(acfdewy18w9cdifff[2:26,i],col="dark green",pch=3)
	points(acfdewy18w9ncdifff[2:26,i],col="blue",pch=3)
	points(acfdewy18w15ncdifff[2:26,i],col="dark blue",pch=3)
	points(acfdewy15w5ncdifff[2:26,i],col="purple",pch=3)
	points(acfdewy15w9cdifff[2:26,i],col="magenta",pch=3)
	points(acfdewy15w9ncdifff[2:26,i],col="pink",pch=3)
	points(acfdewy15w15ncdifff[2:26,i],col="brown",pch=3)
} # saved as wyffc_fig11_2650

par(mfrow=c(5,5))
for (i in 51:75){
	plot(acfdewydifff[2:26,i],main=paste('Station ',i),xlab="lag",ylab="acf",ylim=c(0,1),pch=19)
	points(acfdewy25cdifff[2:26,i],col="red",pch=3)
	points(acfdewy20w3cdifff[2:26,i],col="dark orange",pch=3)
	points(acfdewy18w5ncdifff[2:26,i],col="orange",pch=3)
	points(acfdewy18w9cdifff[2:26,i],col="dark green",pch=3)
	points(acfdewy18w9ncdifff[2:26,i],col="blue",pch=3)
	points(acfdewy18w15ncdifff[2:26,i],col="dark blue",pch=3)
	points(acfdewy15w5ncdifff[2:26,i],col="purple",pch=3)
	points(acfdewy15w9cdifff[2:26,i],col="magenta",pch=3)
	points(acfdewy15w9ncdifff[2:26,i],col="pink",pch=3)
	points(acfdewy15w15ncdifff[2:26,i],col="brown",pch=3)
} # saved as wyffc_fig11_5175

# From these plots I have definitely narrowed down to either 15w9 or 18w9 => Look at their autocorrelations:

summary(t(acfdewydiff[2:6,])) 
# Lag1: (0.1408,0.2538,0.2978,0.3422,0.5828)
# Lag 2: (-0.01456, 0.09936,0.14035,0.19988, 0.47784)
# Lag3: (0.008002,0.100128,0.130281,0.177339,0.483435)
# Lag4: (0.01646,0.09570,0.13306,0.15544,0.46693)
# Lag5: (0.03831,0.09313, 0.12226,0.14801,0.46021)
summary(t(acfdewy25cdiff[2:6,]))
# Lag1: (0.03942, 0.10636, 0.21581, 0.35221, 0.92837)
# Lag2: (0.01532, 0.08470, 0.18226, 0.34845, 0.92157)
# Lag3: (0.003902, 0.065719, 0.165128, 0.343491, 0.918642)
# Lag4: (0.007672, 0.059676, 0.183661, 0.336346, 0.916074)
# Lag5: (0.006165, 0.063607, 0.178175, 0.342079, 0.915673)
summary(t(acfdewy18w9cdiff[2:6,]))
# Lag1: (0.3509, 0.3802, 0.3972, 0.4223, 0.6241)
# Lag2: (0.2192, 0.2406, 0.2576, 0.2917, 0.5472)
# Lag3: (0.1685, 0.1981, 0.2216, 0.2521, 0.5123)
# Lag4: (0.1563, 0.1861, 0.2063, 0.2391, 0.5103)
# Lag5: (0.1292, 0.1636, 0.1790, 0.2095, 0.4964)
summary(t(acfdewy15w9cdiff[2:6,]))
# Lag1: (0.3296, 0.3789, 0.3917, 0.4076, 0.5378)
# Lag2: (0.1979, 0.2362, 0.2525, 0.2780, 0.4214)
# Lag3: (0.1593, 0.1881, 0.2083, 0.2335, 0.3983)
# Lag4: (0.1409, 0.1800, 0.1992, 0.2199, 0.3973)
# Lag5: (0.1381, 0.1609, 0.1741, 0.1960, 0.3830)

# And look when I've calculated using first differences:

summary(t(acfdewydifff[2:6,])) 
# Lag1: (0.1941,0.2781,0.3325,0.4004,0.5930)
# Lag 2: (0.009947, 0.130894,0.191096,0.228005,0.477839)
# Lag3: (0.03269,0.11444,0.16231,0.19077,0.48343)
# Lag4: (0.04818,0.10874,0.14366,0.17705,0.46693)
# Lag5: (0.04668,0.10494, 0.13765,0.16523,0.46021)
summary(t(acfdewy18w9cdifff[2:6,]))
# Lag1: (0.3509, 0.3959, 0.4196, 0.4914, 0.7346)
# Lag2: (0.2245, 0.2534, 0.2862, 0.3671, 0.6631)
# Lag3: (0.1872, 0.2093, 0.2369, 0.3387, 0.6351)
# Lag4: (0.1671, 0.1973, 0.2332, 0.3213, 0.6291)
# Lag5: (0.1428, 0.1691, 0.2007, 0.3089, 0.6196)
summary(t(acfdewy15w9cdifff[2:6,]))
# Lag1: (0.3673, 0.3913, 0.4237, 0.4611, 0.6836)
# Lag2: (0.2122, 0.2536, 0.2919, 0.3384, 0.6089)
# Lag3: (0.1641, 0.2071, 0.2359, 0.3033, 0.5874)
# Lag4: (0.1561, 0.1983, 0.2570, 0.2930, 0.5786)
# Lag5: (0.1394, 0.1691, 0.1975, 0.2738, 0.5840)

