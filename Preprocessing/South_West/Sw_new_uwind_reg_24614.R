# This document is an update of the 2114 documents in an attempt to speed up my interpolation process!

# First load all the packages which might be helpful:

library(ncdf)
library(ncdf4)
library(akima)
library(fields)

# Now read in the data:

swalluw8114 <- open.ncdf('uwind_sw2114.nc') # This should be sea level pressure data on 2x2 grid squares for -82 to -66 (278 to 294) longitude and 40 to 50 latitude

x8114 <- get.var.ncdf(swalluw8114, "lat")          # coordinate variable = 40.9517 39.0470 37.1422 35.2375 33.3328 31.4281 (29.5234 - got rid of)
y8114 <- get.var.ncdf(swalluw8114, "lon")          #  coordinate variable = (234.375 - got rid of) 236.250 238.125 240.000 241.875 243.750 245.625 247.500 (249.375 - got rid of)
yneg8114 <- y8114-360				 # Currently the longitudes are between 0 and 360, I want my longitudes here to match the longitudes from the GHCND data => by subtracting 360 I make them match (I hope!)

uwall8114 <- get.var.ncdf(swalluw8114) 	         # UW for each day from 1st January 1970 to 31st December 2011 - a matrix with 6 columns and 7 rows 

# Useful for table later on in code:

lat8114a=cbind(c(rep(31.4281,7),rep(33.3328,7),rep(35.2375,7),rep(37.1422,7),rep(39.0470,7),rep(40.9517,7)))
lon8114a=cbind(c(rep(yneg8114,6)))

# Create a data frame for my info to be stored in

uwinterpp8114a=data.frame(matrix(ncol=2,nrow=21169200))

# Read in my station information

load('/scratch/rw307/Reading/Scripts/SouthWest/SWregcoast1.RData')

swele=SWregcoast1
names(swele)=c('Code','Lat','Long','Elevation')
swele$Code=seq(1,1380)

# Now I want a loop so I can look at all 15340 days without having to change anything manually

i=1 

for (i in 1:15340) {

# Read in the data

uw8114=uwall8114[,,i]
UW8114a=cbind(c(uw8114[,6],uw8114[,5],uw8114[,4],uw8114[,3],uw8114[,2],uw8114[,1]))
call8114a=interpp(lat8114a,lon8114a,UW8114a,swele$Lat,swele$Long, linear=TRUE, extrap=FALSE, duplicate = "error")

j=1380*(i-1)+1
j1=1380*i
uwinterpp8114a[j:j1,1]=call8114a$z
uwinterpp8114a[j:j1,2]=swele$Code

}

uwinterpp8114b=uwinterpp8114a[with(uwinterpp8114a, order(uwinterpp8114a[,2])), ]
uwinterpp8114c=uwinterpp8114b[,1]

save(uwinterpp8114c,file='uwind_sw24614.RData')

rm(uwinterpp8114a,uwinterpp8114b,uwinterpp8114c,call8114a,i,j,j1,lat8114a,lon8114a,swalluw8114,swele,SWregcoast1,uw8114,UW8114a,uwall8114,x8114,y8114,yneg8114)



