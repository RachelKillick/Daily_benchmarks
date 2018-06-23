# This document is an update of the 2114 documents in an attempt to speed up my interpolation process!

# First load all the packages which might be helpful:

library(ncdf)
library(ncdf4)
library(akima)
library(fields)

# Now read in the data:

swalltempf8114 <- open.ncdf('tempf_sw2114.nc') # This should be sea level pressure data on 2x2 grid squares for -82 to -66 (278 to 294) longitude and 40 to 50 latitude

x8114 <- get.var.ncdf(swalltempf8114, "lat")          # coordinate variable = 40.9517 39.0470 37.1422 35.2375 33.3328 31.4281 (29.5234 - got rid of)
y8114 <- get.var.ncdf(swalltempf8114, "lon")          #  coordinate variable = (234.375 - got rid of) 236.250 238.125 240.000 241.875 243.750 245.625 247.500 (249.375 - got rid of)
yneg8114 <- y8114-360				 # Currently the longitudes are between 0 and 360, I want my longitudes here to match the longitudes from the GHCND data => by subtracting 360 I make them match (I hope!)

tempfall8114 <- get.var.ncdf(swalltempf8114) 	         # TEMPF for each day from 1st January 1970 to 31st December 2011 - a matrix with 6 columns and 7 rows 

# Useful for table later on in code:

lat8114a=cbind(c(rep(31.4281,7),rep(33.3328,7),rep(35.2375,7),rep(37.1422,7),rep(39.0470,7),rep(40.9517,7)))
lon8114a=cbind(c(rep(yneg8114,6)))

# Create a data frame for my info to be stored in

tempfinterpp8114a=data.frame(matrix(ncol=2,nrow=21169200))

# Read in my station information

load('/scratch/rw307/Reading/Scripts/SouthWest/SWregcoast1.RData')

swele=SWregcoast1
names(swele)=c('Code','Lat','Long','Elevation')
swele$Code=seq(1,1380)

# Now I want a loop so I can look at all 15340 days without having to change anything manually

i=1 

for (i in 1:15340) {

# Read in the data

tempf8114=tempfall8114[,,i]
TEMPF8114a=cbind(c(tempf8114[,6]-273.15,tempf8114[,5]-273.15,tempf8114[,4]-273.15,tempf8114[,3]-273.15,tempf8114[,2]-273.15,tempf8114[,1]-273.15))
call8114a=interpp(lat8114a,lon8114a,TEMPF8114a,swele$Lat,swele$Long, linear=TRUE, extrap=FALSE, duplicate = "error")

j=1380*(i-1)+1
j1=1380*i
tempfinterpp8114a[j:j1,1]=call8114a$z
tempfinterpp8114a[j:j1,2]=swele$Code

}

tempfinterpp8114b=tempfinterpp8114a[with(tempfinterpp8114a, order(tempfinterpp8114a[,2])), ]
tempfinterpp8114c=tempfinterpp8114b[,1]

save(tempfinterpp8114c,file='tempf_sw24614.RData')

rm(tempfinterpp8114a,tempfinterpp8114b,tempfinterpp8114c,call8114a,i,j,j1,lat8114a,lon8114a,swalltempf8114,swele,SWregcoast1,tempf8114,TEMPF8114a,tempfall8114,x8114,y8114,yneg8114)



