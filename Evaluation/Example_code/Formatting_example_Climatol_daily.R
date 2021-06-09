# The data is returned in the same form it was released in, this code puts it back into a dataframe in R (also with NAs instead of -9999 for missing values). This code is an example script for formatting returned data before analysing it. The example is given for formatting the Climatol-daily contribution for the South East best gues for the real world scenario, but can be adapted to other scenarios, regions and algorithms.

### THIS SCRIPT IS FOR READING IN RETURNED DATA AND OUTPUTTING IN R FORMAT ###

#### SOUTH EAST WORLD 1 (BEST GUESS FOR THE REAL WORLD) ######### 

codes=read.table('Station_codes_created_for_SE_241014.txt')
codes=codes[1:153,]

climd=as.data.frame(matrix(nrow=2347020,ncol=1))

# Will need to unzip Climatol_daily-SE-1 before proceeding with the next step:

for (i in 1:153){
	stat=scan(paste('Climatol_daily-SE_1/',codes[i],'.dly',sep=""),what='raw')
	statn=stat[-seq(1,16128,by=32)] # Get rid of the station and month references 
	stats=as.data.frame(cbind(as.numeric(statn),rep(1:372,42))) # Give each entry a 'day' identifier 
	statt=stats[stats[,2]!=c(61,62),] # Get rid of the 'days' that don't really exist 30th and 31st Feb
	statt=statt[statt[,2]!=124,] # Get rid of the 'days' that don't really exist 31st April
	statt=statt[statt[,2]!=186,] # Get rid of the 'days' that don't really exist 31st June
	statt=statt[statt[,2]!=279,] # Get rid of the 'days' that don't really exist 31st September
	statt=statt[statt[,2]!=341,] # Get rid of the 'days' that don't really exist 31st November
	statt$Time=1:15372 # Add a time identifier
	statf=statt[statt$Time[c(-60,-426,-1158,-1524,-1890,-2622,-2988,-3354,-4086,-4452,-4818,-5550,-5916,-6282,-7014,-7380,-7746,-8478, -8844,-9210,-9942,-10308,-10674,-11406,-11772,-12138,-12870,-13236,-13602,-14334,-14700,-15066)],] # Get rid of the 29th Feb in none leap years.
	climd[((i-1)*15340+1):(i*15340),1]=statf[,1] # Have to have this column identifier here, otherwise it doesn't read in the info correctly
}

##### THESE LINES ALSO ADD IN THE CLEAN AND CORRUPTED RELEASED VERSIONS OF THE DATA AND THEN ROUND TO THE APPROPRIATE NUMBER OF DP. The .RData files are available on request from rachel.killick@metoffice.gov.uk, but are too large to upload to GitHub. ######

# Load in the data frame containing the clean and inhomogeneous data:
load('SE_world_1_241014.RData')

# Make the released inhomogeneous data missing to the same level as the observed TMEAN data:
m=which(colnames(Predictsetf)=="Inhomogeneous")
Predictsetf[is.na(Predictsetf$TMEAN),m] <- NA 

# Now put the station reference, time reference, observations, clean, corrupted and returned data in one data frame in the same units (returned data were in tenths of a degree C).
climd1=as.data.frame(cbind(Predictsetf$Station,Predictsetf$Time,Predictsetf$TMEAN,Predictsetf$lsmodel45,Predictsetf$Inhomogeneous,(climd[,1]/10)))
colnames(climd1)=c('Station','Time','TMEAN','Clean','Corrupted','Returned')

# And make the returned data missing to the same level as the observed and released data too:
m=which(colnames(climd1)=="Returned")
climd1[is.na(climd1$TMEAN),m] <- NA 

# The clean data should also be degraded to have the same level of missing data as the released world (and any returned data where interpolation has occurred):

climd1$Cleanm=climd1$Clean
m=which(colnames(climd1)=="Cleanm")
climd1[is.na(climd1$TMEAN),m] <- NA # Now the released, the returned and the Cleanm columns all have data missing to the same level

# To make comparisons fair it was decided that the clean and corrupted temperatures should also be rounded to point one of a degree:

climdr=round(climd1,1)

## Some of the measures will want to work with deseasonalised data => Deseasonalise at this stage - for the created data it really doesn't make much difference whether you deseasonalise data that has or hasn't already been rounded to one dp, but given that the returned data is only to one dp I will use the released and clean data deseasonalisations that were created from data rounded to 1dp and put into one column => I want deseasonsew1c1 and deseasonsew1i1 from the following file:

load('SE_world1_deseasonalied.RData')

# Then I want to put them into one long column instead of one column per station:

sew1deseasonalised=as.data.frame(matrix(nrow=2347020,ncol=2))
names(sew1deseasonalised)=c('Cleand1','Ihd1')

for (i in 1:153){
	sew1deseasonalised$Cleand1[((i-1)*15340+1):(i*15340)]=deseasonsew1c1[,i]
	sew1deseasonalised$Ihd1[((i-1)*15340+1):(i*15340)]=deseasonsew1i1[,i]
}

############# THESE LINES ADD A DAY IDENTIFIER INTO THE DATAFRAME AND THEN USE THIS INFORMATION TO CALCULATE MEANS AND DESEASONALISE THE RETURNED DATA #######

dataran=climdr # This is so that the script can be generalised more easily - i.e. I won't have to change it in so many places to read in a different dataset

dataran$Dyear=Predictsetf$Dyear

# Create a data frame that contains the mean for each day of the year for each station accounting for leap years:
menrt=as.data.frame(matrix(nrow=366,ncol=153))

for (i in 1:153){
	stat=dataran[dataran$Station==i,]
	statn29=stat[stat$Dyear!=59.5,]
	stat29=stat[stat$Dyear==59.5,]
	statarrt=t(array(statn29$Returned,dim=c(365,42)))
	menrt[1:59,i]=apply(statarrt[,1:59],2,mean,na.rm=TRUE)
	menrt[61:366,i]=apply(statarrt[,60:365],2,mean,na.rm=TRUE)
	menrt[60,i]=mean(stat29$Returned,na.rm=TRUE)
} 

# These lines put the means into dataframes where each column is the mean for each station and the 29th Feb is only present in the correct years:

menrt1=rbind(menrt[-60,],menrt[-60,],menrt,menrt[-60,],menrt[-60,],menrt[-60,],menrt,menrt[-60,],menrt[-60,],menrt[-60,],menrt,menrt[-60,],menrt[-60,],menrt[-60,],menrt,menrt[-60,],menrt[-60,],menrt[-60,],menrt,menrt[-60,],menrt[-60,],menrt[-60,],menrt,menrt[-60,],menrt[-60,],menrt[-60,],menrt,menrt[-60,],menrt[-60,],menrt[-60,],menrt,menrt[-60,],menrt[-60,],menrt[-60,],menrt,menrt[-60,],menrt[-60,],menrt[-60,],menrt,menrt[-60,],menrt[-60,],menrt[-60,])

# Remove the previous dataset from memory to save space (and lessen the probability of errors):
rm(menrt)

# Now create a deseasonalised column in the dataran dataframe for the returned data:

for (i in 1:153){
	dataran$deseasrt[((i-1)*15340+1):(i*15340)]=dataran$Returned[((i-1)*15340+1):(i*15340)]-menrt1[,i]
}

# And add the clean and released deseasonalised data into this dataframe too:

dataran$deseasoncl=sew1deseasonalised$Cleand1
dataran$deseasonrl=sew1deseasonalised$Ihd1

########## Then create a slimmed down second version of this dataset (i.e. without the missing data) and add year and month indicators to it and then add a new Timeframe (accounting for the missing days) ########

dataran1=na.omit(dataran)

load('SEW1_missing_un.RData')

dataran1[,12:14]=Predictsetf4[,29:31] # These numbers need to be watched out for and changed accordingly to ensure nothing is overwritten 

# At this point save the dataframe as it will now be in the format expected for the adjustment ability measures:

save(dataran,dataran1,file='Climatol_daily_se1_for_analysis_3915.RData') 

### South East world 1 (best guess for the real world) - breaks ###

# Get the detected breaks into the format expected by the detection assessment (the re-formatting code is dependent on the input format, but this is included as an example of what the output format needs to look like):

test=scan('Climatol-daily_breaks_reformatted_SE1.txt',what='raw') # Reads the lines in and puts each element on a new line

test=as.data.frame(test) # Puts the output into a dataframe
testdat=test[seq(4,715,by=5),] # Get just the dates out

# Use the following loop to get the dates into a dataframe of the format year month day for each break, these go into columns 2, 3 and 4 because the first column is reserved for the station number

testdat1=data.frame(matrix(nrow=length(testdat),ncol=4))
tet1=strsplit(as.vector(testdat),split='-')

for (i in 1:length(tet1)){
	testdat1[i,2]=as.numeric(tet1[[i]][1])
	testdat1[i,3]=as.numeric(tet1[[i]][2])
	testdat1[i,4]=as.numeric(tet1[[i]][3])	
}

# Now need to pair up the breaks with the stations, again this reading code is specific to the returned break format:

tet=(scan('Climatol-daily_breaks_reformatted_SE1.txt',what='raw',comment.char='('))

# Put the stations into the dataframe:

for (i in 1:length(tet)){
	testdat1[i,1]=as.numeric(substr(tet[[i]][1],start=3,stop=5))
}

names(testdat1)=c('Station','Year','Month','Day')
testdat1=testdat1[order(testdat1$Station),]

# Also in this data frame it would be good to have what day the break occurred on (in terms of day 1 to 15340) - I think the best way of doing this is writing a small loop:

# First read in and trim a dataframe which has days, months, years and Time in it:

load('wyupdatefeb29gam.RData')

stat1old=wyupdatefeb29gam[wyupdatefeb29gam$Station==1,]

# When there are missing data a break needs to be attributed to the day before the date given for it to work:

for (i in 1:nrow(testdat1)){
	day=stat1old[stat1old$Year==testdat1$Year[i] & stat1old$Month==testdat1$Month[i] & stat1old$Day==testdat1$Day[i],]
	testdat1$Time[i]=day$Time-1
}

for (i in 1:nrow(testdat1)){
	day=Predictsetf4[Predictsetf4$Station==testdat1$Station[i] & Predictsetf4$Time==testdat1$Time[i],]
	testdat1$Timenew[i]=day$Timenew
}

save(testdat1,file='Climatol_daily_SEW1_breaks.RData')

