# This document is an update of the 2114 documents in an attempt to speed up my interpolation process!

# First load all the packages which might be helpful:

# rgl and RNetCDF don't seem to be available for my version of R - they don't seem necessary for this script - but it may be worth emailing Rob to ask about getting them installed

library(ncdf)
library(ncdf4)
library(akima)
library(fields)

# Now read in the data:

wyallsun8114 <- open.ncdf('/scratch/rw307/USA/QualityControlled/Wyoming_solar.nc') # This should be sea level pressure data on 2x2 grid squares for -82 to -66 (278 to 294) longitude and 40 to 50 latitude

x8114 <- get.var.ncdf(wyallsun8114, "lat")          # coordinate variable = 46.6658 44.7611 42.8564 40.9517
y8114 <- get.var.ncdf(wyallsun8114, "lon")          # coordinate variable = 247.500 249.375 251.250 253.125 255.000 256.875 258.750
yneg8114 <- y8114-360				 
sunall8114 <- get.var.ncdf(wyallsun8114) 	    # A matrix with 4 columns and 7 rows

# Useful for table later on in code:

lat8114a=cbind(c(rep(40.9517,7),rep(42.8564,7),rep(44.7611,7),rep(46.6658,7)))
lon8114a=cbind(c(rep(yneg8114,4)))

# Create a data frame for my info to be stored in

suninterpp8114a=data.frame(matrix(ncol=2,nrow=14634360))

# Read in my station information

load('/scratch/rw307/Reading/Scripts/Wyoming_new/WYregcoast1.RData')

wyele=WYregcoast1
names(wyele)=c('Code','Lat','Long','Elevation')
wyele$Code=seq(1,954)

# Now I want a loop so I can look at all 15340 days without having to change anything manually

i=1 

for (i in 1:15340) {

# Read in the data

sun8114=sunall8114[,,i]
SUN8114a=cbind(c(sun8114[,4],sun8114[,3],sun8114[,2],sun8114[,1]))
call8114a=interpp(lat8114a,lon8114a,SUN8114a,wyele$Lat,wyele$Long, linear=TRUE, extrap=FALSE, duplicate = "error")

j=954*(i-1)+1
j1=954*i
suninterpp8114a[j:j1,1]=call8114a$z
suninterpp8114a[j:j1,2]=wyele$Code

}

suninterpp8114b=suninterpp8114a[with(suninterpp8114a, order(suninterpp8114a[,2])), ]
suninterpp8114c=suninterpp8114b[,1]

save(suninterpp8114c,file='sun_wy20614.RData')

rm(suninterpp8114a,suninterpp8114b,suninterpp8114c,call8114a,i,j,j1,lat8114a,lon8114a,wyallsun8114,wyele,WYregcoast1,sun8114,SUN8114a,sunall8114,x8114,y8114,yneg8114)



