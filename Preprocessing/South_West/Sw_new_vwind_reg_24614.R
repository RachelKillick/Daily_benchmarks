# This document is an update of the 2114 documents in an attempt to speed up my interpolation process!

# First load all the packages which might be helpful:

library(ncdf)
library(ncdf4)
library(akima)
library(fields)

# Now read in the data:

swallvw8114 <- open.ncdf('vwind_sw2114.nc') # This should be sea level pressure data on 2x2 grid squares for -82 to -66 (278 to 294) longitude and 40 to 50 latitude

x8114 <- get.var.ncdf(swallvw8114, "lat")          # coordinate variable = 40.9517 39.0470 37.1422 35.2375 33.3328 31.4281 (29.5234 - got rid of)
y8114 <- get.var.ncdf(swallvw8114, "lon")          #  coordinate variable = (234.375 - got rid of) 236.250 238.125 240.000 241.875 243.750 245.625 247.500 (249.375 - got rid of)
yneg8114 <- y8114-360				 # Currently the longitudes are between 0 and 360, I want my longitudes here to match the longitudes from the GHCND data => by subtracting 360 I make them match (I hope!)

vwall8114 <- get.var.ncdf(swallvw8114) 	         # VW for each day from 1st January 1970 to 31st December 2011 - a matrix with 6 columns and 7 rows 

# Useful for table later on in code:

lat8114a=cbind(c(rep(31.4281,7),rep(33.3328,7),rep(35.2375,7),rep(37.1422,7),rep(39.0470,7),rep(40.9517,7)))
lon8114a=cbind(c(rep(yneg8114,6)))

# Create a data frame for my info to be stored in

vwinterpp8114a=data.frame(matrix(ncol=2,nrow=21169200))

# Read in my station information

load('/scratch/rw307/Reading/Scripts/SouthWest/SWregcoast1.RData')

swele=SWregcoast1
names(swele)=c('Code','Lat','Long','Elevation')
swele$Code=seq(1,1380)

# Now I want a loop so I can look at all 15340 days without having to change anything manually

i=1 

for (i in 1:15340) {

# Read in the data

vw8114=vwall8114[,,i]
VW8114a=cbind(c(vw8114[,6],vw8114[,5],vw8114[,4],vw8114[,3],vw8114[,2],vw8114[,1]))
call8114a=interpp(lat8114a,lon8114a,VW8114a,swele$Lat,swele$Long, linear=TRUE, extrap=FALSE, duplicate = "error")

j=1380*(i-1)+1
j1=1380*i
vwinterpp8114a[j:j1,1]=call8114a$z
vwinterpp8114a[j:j1,2]=swele$Code

}

vwinterpp8114b=vwinterpp8114a[with(vwinterpp8114a, order(vwinterpp8114a[,2])), ]
vwinterpp8114c=vwinterpp8114b[,1]

save(vwinterpp8114c,file='vwind_sw24614.RData')

rm(vwinterpp8114a,vwinterpp8114b,vwinterpp8114c,call8114a,i,j,j1,lat8114a,lon8114a,swallvw8114,swele,SWregcoast1,vw8114,VW8114a,vwall8114,x8114,y8114,yneg8114)



