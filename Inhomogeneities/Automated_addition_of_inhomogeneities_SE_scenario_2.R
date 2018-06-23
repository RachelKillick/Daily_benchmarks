# South East - World 2

# If we want IHs that propogate backwards and we know that the world is warming then (on average) the last period of the record should be the warmest => An IH that introduces a warm bias should be introduced by cooling all the values prior to that date

library(mgcv) # Necessary for the prediction stage

load('newupd2_for_SE_IH_scripts_241014.RData') # The station data - Need to make sure I have the noise values stored in this dataframe that will need to be added on to the predictions 

# PRIOR TO READING THIS IN need to make sure it is as slimmed down as possible with NO extraneous variables (i.e. it doesn't contain Year, Month, Day, PRCP,TMEAN or TMEAN60 for now (because same missing values can be sorted later) or any outputs of predictions that aren't necessary for this script. Also soinew is the same for all stations there may be a way of reading it in separately and hence making the dataset about a million values smaller - The more uniform I can make it across regions the better) => This will hopefully be a DF with no.of.stats*15340*2 (the *2 is because of the relocation options) rows and 19 columns

# Load the model that the predictions need to be made from:

load('modelsecoast5gf3th1.RData')

Predictset=newupd2
rm(newupd2) # Remove the dataframe newup as I don't want two massive datasets floating around

Predictset$Station=sort(rep(1:210,30680))

Predictset$noise=Predictset$pred5th1-Predictset$lsmodel45a
# pred5th1 = 60 - raw preds
# pred5th1gam = unsmoothed noise - raw preds (i.e. this is the unsmoothed noise that will be added on because the mean has been subtracted)
# lsmodel...= 60 - (smoothed noise + (60 - pred5th1)) = 60 - (smoothed noise + 60 - (60 - raw preds)) = 60 - (smoothed noise + raw preds) = 60 - raw preds - smoothed noise = pred5th1 - smoothed noise => smoothed noise = pred5th1 - lsmodel... 

# Make an extra row that will be storing the new predictions (with added noise)

Predictset$Inhomogeneous=NA # This is column 25

Predictsetf=Predictset[Predictset$Station_Realisation==6,] # Need to create this dataframe otherwise my new predictions and my old dataframe won't have the same number of rows...

# Want to be able to store the location of the inhomogeneities (and their types) not sure how many there will be at each station => make the storage dataframe much bigger than it should need to be (i.e. Suppose 10 inhomogeneities at ALL stations - so as long as they don't all have more than ten it should be OK)

Inhomogeneity=as.data.frame(matrix(nrow=2100,ncol=5))
names(Inhomogeneity)=c('Station','Location','Type','Method','Size_implemented')

# Want to be able to store the length of urbanisation inhomogeneities:

Urbanisation=as.data.frame(matrix(nrow=210,ncol=3)) # Doesn't need to be bigger than 210 as each station can have a max of one inhomogeneity
names(Urbanisation)=c('Station','Location','HalfLength')

num1=1 # This can be updated as I need to keep a running total of what number inhomogeneity I am on overall so I can add to the appropriate row of the data frame (of course if I want clustered inhomogeneities I'll have to still give that some thought of how to correctly add these in)

for (i in 1:210){

	stat=Predictset[Predictset$Station==i & Predictset$Station_Realisation==6,] # This is where the station will end up

	# Run Poisson process to decide location of inhomogeneities:

	loc=round(14610*cumsum(rexp(15,3))) # I'm multiplying by the number of days an IH can occur on 
	loca=na.omit(stat[loc,14]) # Get just the elements that are less than the length of the time series - NEED TO MAKE SURE
	# YOU'RE LOOKING AT THE TIME COLUMN OTHERWISE NAS IN OTHER COLUMNS WILL CAUSE PROBLEMS! 
	
	loca=loca[loca<=14610] # So that inhomogeneities can't occur in the last two years of the record

	loca=sort(loca,decreasing=TRUE) # This just means that my 'last' IH will get implemented first so that they won't
	# interfere with each other in a way I don't like

	# Use a RNG to decide type of inhomgogeneity:

	# Provisionally if we think abrupt changes are more common than gradual:

	n=length(loca) # The number of inhomogeneities we have
	n1=length(loca) # Just so  I'm not using the same index in 2 loops (even though they should be indexed on the same thing!)

	# At this stage I want to make sure there isn't more than one urbanisation IH in a series:

	if (n1 != 0 ){

		inhomog=as.data.frame(matrix(nrow=n1,ncol=1))
	
		inhomog[1,1]=runif(1,0,1)

		for (f in 2:n1){

			g = f - 1
	
			if (sum(inhomog[1:g,1]<=0.67)==g) {
		
				inhomog[f,1]=runif(1,0,1) # The random number for each inhomogeneity	
		
			} else { inhomog[f,1]=runif(1,0,0.67) # Can ONLY be a station relocation or a shelter change (becuase
				# urbanisation has already happened)
			}
		}
	}

        t=runif(n,0,1) # Deciding how the inhomogeneity will be implemented 

	# If the explan var effect is going to be amplified this can be done within the individual bits in the loop...

	if (n==0) { # A quick failsafe (I hope) for if there are no inhomogeneities

		stat = stat

	} else { for (j in 1:n){

				p=loca[j] # So that I have the point at which an inhomogeneity occurs:
	
				if (t[j] <= 0.3){ # Making explanatory variable IH addition more likely than constant offset

					if (inhomog[j,1]<=0.67){ # Shelter change - offset noise

					sc=sample(x=c(1.5,1.25,1,.75,.5,.25,-.25,-.5,-.75,-1,-1.25,-1.5),size=1)

					stat$noise[1:p]=stat$noise[1:p]+sc # Shelter change can have a +ve or -ve effect
	
					}

# Get rid of the station relocation option in this method of adding an inhomogeneity as it would either have to be exactly the same implementation as a shelter change, or the varaibles themselves would have to change which would then change it at the prediction level and not just the noise level

#					if (0.34<=inhomog[j,1] & inhomog[j,1]<=0.67){ # Station Relocation

#					sc=sample(x=c(1.5,1.25,1,.75,.5,.25,-.25,-.5,-.75,-1,-1.25,-1.5),size=1)

					# Even if I'm not using explan vars to implement this change, the station data I'm
					# reading in should change because it may be necssary later in the code

#					sr=stat$Station_Realisation[p]

#					statn=Predictset[Predictset$Station==i & Predictset$Station_Realisation!=sr,]

#					stat[1:p,]=statn[1:p,]

#					stat$noise[1:p]=stat$noise[1:p]+sc

#					}

					if (0.67<inhomog[j,1]){ # Gradual change
					
						l=rnorm(1,mean=5475,sd=1095) # Decide the length of the urbanisation IH
						l2=floor((l/2)) # To make sure the IH has a length divisible by 2!

						# The two if loops here try and ensure that I don't get a very unrealistic IH size
						# over the time period given

							if (l<= 5475){

								sc=sample(x=c(.1,.15,.2),size=1)

							}

							if (l > 5475){
		
								sc=sample(x=c(.15,.2,.25,.5,1,1.25),size=1)

							}	
	
						amp1=seq(sc,(sc/2),length=l2)
						amp2=seq((sc/2),0,length=l2)

							if ((p+l2) > 15340 & (p-l2) <0) { # Overshoots both ends
	
								stat$noise[1:p]=amp1[(l2-p+1):l2]+stat$noise[1:p]
								stat$noise[(p+1):15340]=amp2[1:(15340-p)]+stat$noise[(p+1):15340]
		
							}

							if ((p+l2) > 15340 & (p-l2)>0) { # Overshoots upper end
	
								stat$noise[(p-l2+1):p]=amp1+stat$noise[(p-l2+1):p]
								stat$noise[(p+1):15340]=amp2[1:(15340-p)]+stat$noise[(p+1):15340]
								stat$noise[1:(p-l2)]=amp1[1]+stat$noise[1:(p-l2)]
						
							}

							if ((p+l2) < 15340 & (p+l2) > 14610 & (p-l2) >0 ){ # Would end in final
							# two years of record

								stat$noise[(p-l2+1):p]=amp1+stat$noise[(p-l2+1):p]
								stat$noise[(p+1):14610]=amp2[1:(14610-p)]+stat$noise[(p+1):14610] 
								stat$noise[1:(p-l2)]=amp1[1]+stat$noise[1:(p-l2)]

							}

							if ((p+l2) < 15340 & (p+l2) > 14610 & (p-l2)<0){ # Overshoots lower end
							# and would end in final two years of the record
		
								stat$noise[1:p]=amp1[(l2-p+1):l2]+stat$noise[1:p]
								stat$noise[(p+1):14610]=amp2[1:(14610-p)]+stat$noise[(p+1):14610] 
								
							}

							if ((p+l2) <= 14610 & (p-l2)<0){ # Overshoots lower end
							# and wouldn't end in final two years of the record
		
								stat$noise[1:p]=amp1[(l2-p+1):l2]+stat$noise[1:p]
								stat$noise[(p+1):(p+l2)]=amp2+stat$noise[(p+1):(p+l2)]
		
							}

							if ((p+l2) <= 14610 & (p-l2)>0){ # Doesn't overshoot at all

								stat$noise[(p-l2+1):p]=amp1+stat$noise[(p-l2+1):p]
								stat$noise[(p+1):(p+l2)]=amp2+stat$noise[(p+1):(p+l2)]
								stat$noise[1:(p-l2)]=amp1[1]+stat$noise[1:(p-l2)]

							}

						Urbanisation[i,1]=i
						Urbanisation[i,2]=loca[j]
						Urbanisation[i,3]=l2
							
					}

				} else { 

					if (inhomog[j,1]<0.34){ # Shelter change - could add another loop to decide size and
					# direction
					
						sc=sample(x=c(.85,.9,.95,1.05,1.1,1.15),size=1)

						stat$uw[1:p]=sc*stat$uw[1:p]
						stat$vw[1:p]=sc*stat$vw[1:p]
						stat$sun[1:p]=sc*stat$sun[1:p] # Della-Marta and Wanner 2006
	
					}

					if (0.34<=inhomog[j,1] & inhomog[j,1]<=0.67){ # Station Relocation 

						sr=stat$Station_Realisation[p]
	
						statn=Predictset[Predictset$Station==i & Predictset$Station_Realisation!=sr,]
		
						ns=stat$noise
	
						stat[1:p,]=statn[1:p,]

						stat$noise=ns # To make sure that the underlying predictions are the only things 
						# that are changing - though I suspect this will result in not enough change and 
						# the amplification/ dampening of explanatory vars will also be necessary

						# Need to have an sc (size of change) to store - can't make it NA

						# Can also choose to amplify some of the changes in explanatory variables:
						sc=0 #sample(x=c(.95,1.05),size=1) 
#						stat$uw[1:p]=sc*stat$uw[1:p]
#						stat$vw[1:p]=sc*stat$vw[1:p]
#						stat$sun[1:p]=sc*stat$sun[1:p]
#						stat$pwc[1:p]=sc*stat$pwc[1:p]

					}

					if (0.67<inhomog[j,1]){ # Gradual change 
	
						l=rnorm(1,mean=5475,sd=1095) # Decide the length of the urbanisation IH
						l2=floor((l/2)) # To make sure the IH has a length divisible by 2!
	

						if (l<= 5475){

							sc=.975 # Can only change by the smallest option

						}

						if (l > 5475){
		
							sc=sample(x=c(.925,.95,.975),size=1) # Max anything could increase by is
							# 15% - is this still too much?

						}	

						damp1=seq(sc,(sc+(1-sc)/2),length=l2)
						damp2=seq((sc+(1-sc)/2),1,length=l2)

						amp1=seq((2-sc),(2-(sc+(1-sc)/2)),length=l2)
						amp2=seq((2-(sc+(1-sc)/2)),1,length=l2)

						if ((p+l2) > 15340 & (p-l2) <0) { # Overshoots both ends

							stat$sun[1:p]=damp1[(l2-p+1):l2]*stat$sun[1:p]
#							stat$pwc[1:p]=amp1[(l2-p+1):l2]*stat$pwc[1:p]
							stat$uw[1:p]=amp1[(l2-p+1):l2]*stat$uw[1:p]
							stat$vw[1:p]=amp1[(l2-p+1):l2]*stat$vw[1:p]
							stat$sun[(p+1):15340]=damp2[1:(15340-p)]*stat$sun[(p+1):15340]
#							stat$pwc[(p+1):15340]=amp2[1:(15340-p)]*stat$pwc[(p+1):15340]
							stat$uw[(p+1):15340]=amp2[1:(15340-p)]*stat$uw[(p+1):15340]
							stat$vw[(p+1):15340]=amp2[1:(15340-p)]*stat$vw[(p+1):15340]
	
						}

						if ((p+l2) > 15340 & (p-l2)>0){ # Overshoots upper end
	
							stat$sun[(p-l2+1):p]=damp1*stat$sun[(p-l2+1):p]
#							stat$pwc[(p-l2+1):p]=amp1*stat$pwc[(p-l2+1):p]
							stat$uw[(p-l2+1):p]=amp1*stat$uw[(p-l2+1):p]
							stat$vw[(p-l2+1):p]=amp1*stat$vw[(p-l2+1):p]
							stat$sun[(p+1):15340]=damp2[1:(15340-p)]*stat$sun[(p+1):15340]
#							stat$pwc[(p+1):15340]=amp2[1:(15340-p)]*stat$pwc[(p+1):15340]
							stat$uw[(p+1):15340]=amp2[1:(15340-p)]*stat$uw[(p+1):15340]
							stat$vw[(p+1):15340]=amp2[1:(15340-p)]*stat$vw[(p+1):15340]
						
						}


						if ((p+l2) < 15340 & (p+l2) > 14610 & (p-l2) >0 ){ # Would end in final
							# two years of record

							stat$sun[(p-l2+1):p]=damp1*stat$sun[(p-l2+1):p]
#							stat$pwc[(p-l2+1):p]=amp1*stat$pwc[(p-l2+1):p]
							stat$uw[(p-l2+1):p]=amp1*stat$uw[(p-l2+1):p]
							stat$vw[(p-l2+1):p]=amp1*stat$vw[(p-l2+1):p]
							stat$sun[(p+1):14610]=damp2[1:(14610-p)]*stat$sun[(p+1):14610] 
#							stat$pwc[(p+1):14610]=amp2[1:(14610-p)]*stat$pwc[(p+1):14610] 
							stat$uw[(p+1):14610]=amp2[1:(14610-p)]*stat$uw[(p+1):14610] 
							stat$vw[(p+1):14610]=amp2[1:(14610-p)]*stat$vw[(p+1):14610] 
						}

						if ((p+l2) < 15340 & (p+l2) > 14610 & (p-l2)<0){ # Overshoots lower end
						# and would end in final two years of the record

							stat$sun[1:p]=damp1[(l2-p+1):l2]*stat$sun[1:p]
#							stat$pwc[1:p]=amp1[(l2-p+1):l2]*stat$pwc[1:p]
							stat$uw[1:p]=amp1[(l2-p+1):l2]*stat$uw[1:p]
							stat$vw[1:p]=amp1[(l2-p+1):l2]*stat$vw[1:p]
							stat$sun[(p+1):14610]=damp2[1:(14610-p)]*stat$sun[(p+1):14610] 
#							stat$pwc[(p+1):14610]=amp2[1:(14610-p)]*stat$pwc[(p+1):14610] 
							stat$uw[(p+1):14610]=amp2[1:(14610-p)]*stat$uw[(p+1):14610] 
							stat$vw[(p+1):14610]=amp2[1:(14610-p)]*stat$vw[(p+1):14610] 
						
						}

						if ((p+l2) <= 14610 & (p-l2)<0){ # Overshoots lower end and wouldn't end in final
						# two years of the record
	
							stat$sun[1:p]=damp1[(l2-p+1):l2]*stat$sun[1:p]
#							stat$pwc[1:p]=amp1[(l2-p+1):l2]*stat$pwc[1:p]
							stat$uw[1:p]=amp1[(l2-p+1):l2]*stat$uw[1:p]
							stat$vw[1:p]=amp1[(l2-p+1):l2]*stat$vw[1:p]
							stat$sun[(p+1):(p+l2)]=damp2*stat$sun[(p+1):(p+l2)]
#							stat$pwc[(p+1):(p+l2)]=amp2*stat$pwc[(p+1):(p+l2)]
							stat$uw[(p+1):(p+l2)]=amp2*stat$uw[(p+1):(p+l2)]
							stat$vw[(p+1):(p+l2)]=amp2*stat$vw[(p+1):(p+l2)]
	
						}

						if ((p+l2) <= 14610 & (p-l2)>0){ # Doesn't overshoot at all

							stat$sun[(p-l2+1):p]=damp1*stat$sun[(p-l2+1):p]
#							stat$pwc[(p-l2+1):p]=amp1*stat$pwc[(p-l2+1):p]
							stat$uw[(p-l2+1):p]=amp1*stat$uw[(p-l2+1):p]
							stat$vw[(p-l2+1):p]=amp1*stat$vw[(p-l2+1):p]
							stat$sun[(p+1):(p+l2)]=damp2*stat$sun[(p+1):(p+l2)]
#							stat$pwc[(p+1):(p+l2)]=amp2*stat$pwc[(p+1):(p+l2)]
							stat$uw[(p+1):(p+l2)]=amp2*stat$uw[(p+1):(p+l2)]
							stat$vw[(p+1):(p+l2)]=amp2*stat$vw[(p+1):(p+l2)]
						}

						if ((p-l2)>0){ # So we don't have overshoot at the lower end and I'm hoping this 
						# will work even if one of the other loops has already been called...

							statval=mean((60-predict.gam(modelsecoast5gf3th1,newdata=stat[(p-l2+1):(p-l2+10),],type="response"))-(stat[(p-l2+1):(p-l2+10),21])) # Get a starting value for the urbanisation IH - the 21 needs to be whatever column is lsmodel...
							stat$noise[1:(p-l2)]=statval+stat$noise[1:(p-l2)]

						}


					Urbanisation[i,1]=i
					Urbanisation[i,2]=loca[j]
					Urbanisation[i,3]=l2
					
					}
	
				}
	
			Inhomogeneity$Station[(num1)]=stat$Station[1]
			Inhomogeneity$Location[(num1)]=loca[j]
			Inhomogeneity$Type[(num1)]=inhomog[j,1]
			Inhomogeneity$Method[(num1)]=t[j]
			Inhomogeneity$Size_implemented[(num1)]=sc

			num1=num1+1
		
		}

	}

	statnew=(60-predict.gam(modelsecoast5gf3th1,newdata=stat,type="response"))
	Predictsetf[Predictsetf$Station==i,25]=statnew-stat$noise # The 25 here needs to be reset to be whichever column is the
	# column called Inhomogeneous	

}

# This preliminary work is looking promising => SAVE IT:

Inhomogeneity=na.omit(Inhomogeneity) # So I don't have all the extra rows that I initially created to store my values in 
Urbanisation=na.omit(Urbanisation)

Urbanisation1=Urbanisation # So I can keep the existing Urbanisation dataframe as it is and don't have to worry about accidentally corrupting it!

Urbanisation1$Start=Urbanisation1$Location-Urbanisation1$HalfLength
Urbanisation1$End=Urbanisation1$Location+Urbanisation1$HalfLength

Urbanisation1[Urbanisation1$Start<1,4]=1 # So ones that over-run are marked as starting on day 1
Urbanisation1[Urbanisation1$End >14610 & Urbanisation1$End <= 15340,5 ]=14610 # So ones that would finish in the last 2 years are marked as finishing on day 14610 (31/12/09)
# Don't know what to do about those that over-run completely and are still going when the record ends - double check that we're DEFINITELY happy with these happening...

Predictsetf$Difference=Predictsetf$Inhomogeneous-Predictsetf$lsmodel45a

Predictsetf1=Predictsetf

load('Missing_data_in_world3_SE_241014.RData')

Predictsetf1$TMEAN=TMEAN

Predictsetf1[is.na(Predictsetf1$TMEAN),25] <- NA # Need to make sure that Predictsetf actually HAS a TMEAN column for this to work!
Predictsetf1$Difference=Predictsetf1$Inhomogeneous-Predictsetf1$lsmodel45a

save(Inhomogeneity,Predictsetf,Predictsetf1,Urbanisation,Urbanisation1,file="SE_world2_IHs_241014.RData") 

Inhomogeneity1=Inhomogeneity # This way I have a copy of my original dataframe in case anything goes wrong!

# The size of an inhomogeneity over a time-period will be the difference between the inhomogeneous series and the clean series (ls...) (probably averaged) over that time period
# Think about whether people are going to homogenise relative to the last homogeneous sub-period or the period next to where they are - my inhomogeneities are going to stack one on top of each other, so if someone doesn't find one I need to think about what that will look like for them, so I know how to assess it...

Inhomogeneity1$MEAN=NULL
Inhomogeneity1$MEDIAN=NULL

Inhomogeneitysub1=NULL

for (s in 1:210){

	stat=Predictsetf1[Predictsetf1$Station==s,]	
	Inhomogeneitysub=Inhomogeneity1[Inhomogeneity1$Station==s,]
	Inhomogeneitysub=Inhomogeneitysub[with(Inhomogeneitysub,order(Location)),]
	t=nrow(Inhomogeneitysub)

	if (t==0){
	#If this is true (i.e. t=0) I don't want anything to happen - so I'll see if this does what I expect...
	}

	if (t==1){

		Inhomogeneitysub$MEAN[t]=mean(stat$Difference[1:(Inhomogeneitysub$Location[t])],na.rm=TRUE)
		Inhomogeneitysub$MEDIAN[t]=median(stat$Difference[1:(Inhomogeneitysub$Location[t])],na.rm=TRUE)
		Inhomogeneitysub$Length[t]=length(stat$Difference[1:(Inhomogeneitysub$Location[t])])

	} 
	
	if (t>1) {

		for (u in 1:t){

			if (u==1){

				Inhomogeneitysub$MEAN[u]=mean(stat$Difference[1:(Inhomogeneitysub$Location[u])],na.rm=TRUE)
				Inhomogeneitysub$MEDIAN[u]=median(stat$Difference[1:(Inhomogeneitysub$Location[u])],na.rm=TRUE)
				Inhomogeneitysub$Length[u]=length(stat$Difference[1:(Inhomogeneitysub$Location[u])])

			} 
		
			if (u >1){
	
			Inhomogeneitysub$MEAN[u]=mean(stat$Difference[(Inhomogeneitysub$Location[u-1]):(Inhomogeneitysub$Location[u])],na.rm=TRUE)	
			Inhomogeneitysub$MEDIAN[u]=median(stat$Difference[(Inhomogeneitysub$Location[u-1]):(Inhomogeneitysub$Location[u])],na.rm=TRUE)				
			Inhomogeneitysub$Length[u]=length(stat$Difference[(Inhomogeneitysub$Location[u-1]):(Inhomogeneitysub$Location[u])])	
				
			}
		}	
	}

	Inhomogeneitysub1=rbind(Inhomogeneitysub1,Inhomogeneitysub)

}

#Inhomogeneitysub2=Inhomogeneitysub1 # So if I accidentally corrupt anything I have something to work back to!
#Inhomogeneitysub2[Inhomogeneitysub2$Method<=0.3,4] <- 'co'
#Inhomogeneitysub2[Inhomogeneitysub2$Method!='co',4] <- 'ev'
#Inhomogeneitysub2[Inhomogeneitysub2$Method=='co' & Inhomogeneitysub2$Type <= 0.67, 3] <- 'sc'
#Inhomogeneitysub2[Inhomogeneitysub2$Method=='co' & Inhomogeneitysub2$Type != 'sc', 3] <- 'urb'
#Inhomogeneitysub2[Inhomogeneitysub2$Method!='co' & Inhomogeneitysub2$Type < 0.34, 3] <- 'sc'
#Inhomogeneitysub2[Inhomogeneitysub2$Method!='co' & Inhomogeneitysub2$Type != 'sc' & Inhomogeneitysub2$Type >= 0.34 & #Inhomogeneitysub2$Type <= 0.67 , 3] <- 'sr'
#Inhomogeneitysub2[Inhomogeneitysub2$Method!='co' & Inhomogeneitysub2$Type!= 'sc' & Inhomogeneitysub2$Type!='sr' & Inhomogeneitysub2$Type > 0.67, 3] <- 'urb'

save(Inhomogeneitysub1, file='Inhomogeneitysub1_SE_world2_241014.RData') 

#### Don't want to run past here when I'm running the script on automatic:

#summary(Inhomogeneitysub1$MEAN/Inhomogeneitysub1$Length) # Suggests there may be (one) problem inhomogeneity that is suggesting a temp change of -0.15 degrees a day...

# Would quite like the above tables in a monthly form too to make comparison with PHA easier:

#load('/scratch/rw307/Reading/Scripts/smallerwy_10914.RData')

#smallerwyor=smallerwy[smallerwy$Station_Realisation==6,]

#load('/scratch/rw307/Reading/Scripts/Wyoming_new/wyupdatefeb29gam.RData') # So that my data frames can have a month and year column:

#smallerwyor$Year=wyupdatefeb29gam$Year
#smallerwyor$Month=wyupdatefeb29gam$Month

#summary(smallerwyor$Coast-Predictsetf$Coast)
#summary(smallerwyor$uw-Predictsetf$uw)

#Predictsetf$Year=smallerwyor$Year
#Predictsetf$Month=smallerwyor$Month

#Yearrec=sort(rep(1970:2011,12))
#Monthrec=rep(1:12,42)

#wymonthly22corrupt=as.data.frame(matrix(nrow=37800,ncol=5))
#names(wymonthly22corrupt)=c('Station','Year','Month','Clean','Corrupt')
#wymonthly22corrupt$Station=sort(rep(1:75,504))
#wymonthly22corrupt$Year=Yearrec
#wymonthly22corrupt$Month=Monthrec

#for (i in 1:75){
#	stat=Predictsetf[Predictsetf$Station==i,]
#	for (j in 1970:2011){
#		year=stat[stat$Year==j,]
#			for (k in 1:12){
#				month=year[year$Month==k,]
#				wymonthly22corrupt[((i-1)*504+(j-1970)*12+k),4]=mean(month$lsmodel22,na.omit=TRUE)
#				wymonthly22corrupt[((i-1)*504+(j-1970)*12+k),5]=mean(month$Inhomogeneous,na.omit=TRUE)
#			}
#	}
#}

# Add a column to this dataframe that has month number:

#wymonthly22corrupt$MonthNo=rep(1:504,75)

# Now need my inhomogeneity locations to also have a month number...:

#IHloc=as.data.frame(matrix(nrow=255,ncol=26))

#for (i in 1:255){

#	IHloc[i,]=Predictsetf[Predictsetf$Station==(Inhomogeneity1$Station[i]) & Predictsetf$Time==(Inhomogeneity$Location[i]),]

#} # Getting all the rows where inhomogeneities occur

#names(IHloc)=names(Predictsetf)

#IHloc1=as.data.frame(matrix(nrow=255,ncol=6))

#for (i in 1:255){

#	IHloc1[i,]=wymonthly22corrupt[wymonthly22corrupt$Station==(IHloc$Station[i]) & wymonthly22corrupt$Year==(IHloc$Year[i]) & wymonthly22corrupt$Month==(IHloc$Month[i]),]

#}

# There should perhaps be a little post processing on this to check where my stations have been relocated to so I can make sure I store this new information - but the final Lats, Longs and Elevations people are given will be where the sations end up - not where it starts off and these will be the locations that I decided on in the first place






