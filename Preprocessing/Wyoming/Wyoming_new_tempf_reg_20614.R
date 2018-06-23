# This document is an update of the 2114 documents in an attempt to speed up my interpolation process!

# First load all the packages which might be helpful:

library(ncdf)
library(ncdf4)
library(akima)
library(fields)

# Now read in the data:

wyalltempf8114 <- open.ncdf('/scratch/rw307/USA/QualityControlled/Wyoming_mean.nc') # This should be sea level pressure data on 2x2 grid squares for -82 to -66 (278 to 294) longitude and 40 to 50 latitude

x8114 <- get.var.ncdf(wyalltempf8114, "lat")          # coordinate variable = 46.6658 44.7611 42.8564 40.9517
y8114 <- get.var.ncdf(wyalltempf8114, "lon")          # coordinate variable = 247.500 249.375 251.250 253.125 255.000 256.875 258.750
yneg8114 <- y8114-360				 
tempfall8114 <- get.var.ncdf(wyalltempf8114) 	    # A matrix with 4 columns and 7 rows

# Useful for table later on in code:

lat8114a=cbind(c(rep(40.9517,7),rep(42.8564,7),rep(44.7611,7),rep(46.6658,7)))
lon8114a=cbind(c(rep(yneg8114,4)))

# Create a data frame for my info to be stored in

tempfinterpp8114a=data.frame(matrix(ncol=2,nrow=14634360))

# Read in my station information

load('/scratch/rw307/Reading/Scripts/Wyoming_new/WYregcoast1.RData')

wyele=WYregcoast1
names(wyele)=c('Code','Lat','Long','Elevation')
wyele$Code=seq(1,954)

# Now I want a loop so I can look at all 15340 days without having to change anything manually

i=1 

for (i in 1:15340) {

# Read in the data

tempf8114=tempfall8114[,,i]
TEMPF8114a=cbind(c(tempf8114[,4]-273.15,tempf8114[,3]-273.15,tempf8114[,2]-273.15,tempf8114[,1]-273.15))
call8114a=interpp(lat8114a,lon8114a,TEMPF8114a,wyele$Lat,wyele$Long, linear=TRUE, extrap=FALSE, duplicate = "error")

j=954*(i-1)+1
j1=954*i
tempfinterpp8114a[j:j1,1]=call8114a$z
tempfinterpp8114a[j:j1,2]=wyele$Code

}

tempfinterpp8114b=tempfinterpp8114a[with(tempfinterpp8114a, order(tempfinterpp8114a[,2])), ]
tempfinterpp8114c=tempfinterpp8114b[,1]

save(tempfinterpp8114c,file='tempf_wy20614.RData')

rm(tempfinterpp8114a,tempfinterpp8114b,tempfinterpp8114c,call8114a,i,j,j1,lat8114a,lon8114a,wyalltempf8114,wyele,WYregcoast1,tempf8114,TEMPF8114a,tempfall8114,x8114,y8114,yneg8114)



