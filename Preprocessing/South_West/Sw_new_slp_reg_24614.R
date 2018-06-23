# This document is an update of the 2114 documents in an attempt to speed up my interpolation process!

# First load all the packages which might be helpful:

library(ncdf)
library(ncdf4)
library(akima)
library(fields)

# Now read in the data:

swallslp8114 <- open.ncdf('slp_sw2114.nc') # This should be sea level pressure data on 2x2 grid squares for -82 to -66 (278 to 294) longitude and 40 to 50 latitude

x8114 <- get.var.ncdf(swallslp8114, "lat")          # coordinate variable = 40 38 36 34 32 30
y8114 <- get.var.ncdf(swallslp8114, "lon")          # coordinate variable = 236 238 240 242 244 246 248
yneg8114 <- y8114-360				 # Currently the longitudes are between 0 and 360, I want my longitudes here to match the longitudes from the GHCND data => by subtracting 360 I make them match (I hope!)

slpall8114 <- get.var.ncdf(swallslp8114) 	         # SLP for each day from 1st January 1970 to 31st December 2011 - a matrix with 6 columns and 7 rows 

# Useful for table later on in code:

lat8114a=cbind(c(rep(30,7),rep(32,7),rep(34,7),rep(36,7),rep(38,7),rep(40,7)))
lon8114a=cbind(c(rep(yneg8114,6)))

# Create a data frame for my info to be stored in

slpinterpp8114a=data.frame(matrix(ncol=2,nrow=21169200))

# Read in my station information

load('/scratch/rw307/Reading/Scripts/SouthWest/SWregcoast1.RData')

swele=SWregcoast1
names(swele)=c('Code','Lat','Long','Elevation')
swele$Code=seq(1,1380)

# Now I want a loop so I can look at all 15340 days without having to change anything manually

i=1 

for (i in 1:15340) {

# Read in the data

slp8114=slpall8114[,,i]
SLP8114a=cbind(c(slp8114[,6],slp8114[,5],slp8114[,4],slp8114[,3],slp8114[,2],slp8114[,1]))
call8114a=interpp(lat8114a,lon8114a,SLP8114a,swele$Lat,swele$Long, linear=TRUE, extrap=FALSE, duplicate = "error")

j=1380*(i-1)+1
j1=1380*i
slpinterpp8114a[j:j1,1]=call8114a$z
slpinterpp8114a[j:j1,2]=swele$Code

}

slpinterpp8114b=slpinterpp8114a[with(slpinterpp8114a, order(slpinterpp8114a[,2])), ]
slpinterpp8114c=slpinterpp8114b[,1]

save(slpinterpp8114c,file='slp_sw24614.RData')

rm(slpinterpp8114a,slpinterpp8114b,slpinterpp8114c,call8114a,i,j,j1,lat8114a,lon8114a,swallslp8114,swele,SWregcoast1,slp8114,SLP8114a,slpall8114,x8114,y8114,yneg8114)



