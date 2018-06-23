# Load the Southern Oscillation Index as a csv table as downloaded from the Australian Bureau of Meteorology:

SOI=read.csv('SOI.csv')
SOItrim=SOI[,2:13] # Get rid of the year variable (for now)

# Turn this into a one dimensional array:

SOIcol = as.vector(t(SOItrim))

# To get the day numbers for the first day of each month load an old version of the dataset:

WYGAMslp=read.table('WYGAMslp.txt')

# These are the time points I need to interpolate for:
want=WYGAMslp[WYGAMslp$Day != '1' & WYGAMslp$Station==1,]

# Get the time points for first day of each month:
frame = WYGAMslp[WYGAMslp$Day == '1' & WYGAMslp$Station==1,6]
frame = cbind(frame,SOIcol)

# Getting a value for 1st January 2012 so that I don't have a weird cut off point
frame=rbind(frame,c(15341,9.4)) 

# Finally, linearly interpolate:

library(stats)

test=approx(frame[,1],frame[,2],seq(1:15340),method="linear")

