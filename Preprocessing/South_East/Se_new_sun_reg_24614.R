# This document is an update of the 2114 documents in an attempt to speed up my interpolation process!

# First load all the packages which might be helpful:

library(ncdf)
library(ncdf4)
library(akima)
library(fields)

# Now read in the data:

seallsun8114 <- open.ncdf('sun_se2114.nc') # This should be sea level pressure data on 2x2 grid squares for -82 to -66 (278 to 294) longitude and 40 to 50 latitude

x8114 <- get.var.ncdf(seallsun8114, "lat")          # coordinate variable = 35.2375 33.3328 31.4281 29.5234 27.6186 25.7139 23.8092
y8114 <- get.var.ncdf(seallsun8114, "lon")          #  coordinate variable = 268.125 270.000 271.875 273.750 275.625 277.500 279.375 281.250 
yneg8114 <- y8114-360				 # Currently the longitudes are between 0 and 360, I want my longitudes here to match the longitudes from the GHCND data => by subtracting 360 I make them match (I hope!)

sunall8114 <- get.var.ncdf(seallsun8114) 	         # SLP for each day from 1st January 1970 to 31st December 2011 - a matrix with 7 columns and 8 rows 

# Useful for table later on in code:

lat8114a=cbind(c(rep(23.8092,8),rep(25.7139,8),rep(27.6186,8),rep(29.5234,8),rep(31.4281,8),rep(33.3328,8),rep(35.2375,8)))
lon8114a=cbind(c(rep(yneg8114,7)))

# Create a data frame for my info to be stored in

suninterpp8114a=data.frame(matrix(ncol=2,nrow=19512480))

# Read in my station information

load('/scratch/rw307/Reading/Scripts/SouthEast/SE_regcoast1_2.RData')

seele=SEregcoast1
names(seele)=c('Code','Lat','Long','Elevation')
seele$Code=seq(1,1272)

# Now I want a loop so I can look at all 15340 days without having to change anything manually

i=1 

for (i in 1:15340) {

# Read in the data

sun8114=sunall8114[,,i]
SUN8114a=cbind(c(sun8114[,7],sun8114[,6],sun8114[,5],sun8114[,4],sun8114[,3],sun8114[,2],sun8114[,1]))
call8114a=interpp(lat8114a,lon8114a,SUN8114a,seele$Lat,seele$Long, linear=TRUE, extrap=FALSE, duplicate = "error")

j=1272*(i-1)+1
j1=1272*i
suninterpp8114a[j:j1,1]=call8114a$z
suninterpp8114a[j:j1,2]=seele$Code

}

suninterpp8114b=suninterpp8114a[with(suninterpp8114a, order(suninterpp8114a[,2])), ]
suninterpp8114c=suninterpp8114b[,1]

save(suninterpp8114c,file='sun_se24614.RData')

rm(suninterpp8114a,suninterpp8114b,suninterpp8114c,call8114a,i,j,j1,lat8114a,lon8114a,seallsun8114,seele,SEregcoast1,SEregcoast2,sun8114,SUN8114a,sunall8114,x8114,y8114,yneg8114)



