# This document is an update of the 2114 documents in an attempt to speed up my interpolation process!

# First load all the packages which might be helpful:

library(ncdf)
library(ncdf4)
library(akima)
library(fields)

# Now read in the data:

wyallvwind8114 <- open.ncdf('/scratch/rw307/USA/QualityControlled/Wyoming_vwind.nc') # This should be sea level pressure data on 2x2 grid squares for -82 to -66 (278 to 294) longitude and 40 to 50 latitude

x8114 <- get.var.ncdf(wyallvwind8114, "lat")          # coordinate variable = 46.6658 44.7611 42.8564 40.9517
y8114 <- get.var.ncdf(wyallvwind8114, "lon")          # coordinate variable = 247.500 249.375 251.250 253.125 255.000 256.875 258.750
yneg8114 <- y8114-360				 
vwindall8114 <- get.var.ncdf(wyallvwind8114) 	    # A matrix with 4 columns and 7 rows

# Useful for table later on in code:

lat8114a=cbind(c(rep(40.9517,7),rep(42.8564,7),rep(44.7611,7),rep(46.6658,7)))
lon8114a=cbind(c(rep(yneg8114,4)))

# Create a data frame for my info to be stored in

vwindinterpp8114a=data.frame(matrix(ncol=2,nrow=14634360))

# Read in my station information

load('/scratch/rw307/Reading/Scripts/Wyoming_new/WYregcoast1.RData')

wyele=WYregcoast1
names(wyele)=c('Code','Lat','Long','Elevation')
wyele$Code=seq(1,954)

# Now I want a loop so I can look at all 15340 days without having to change anything manually

i=1 

for (i in 1:15340) {

# Read in the data

vwind8114=vwindall8114[,,i]
VWIND8114a=cbind(c(vwind8114[,4],vwind8114[,3],vwind8114[,2],vwind8114[,1]))
call8114a=interpp(lat8114a,lon8114a,VWIND8114a,wyele$Lat,wyele$Long, linear=TRUE, extrap=FALSE, duplicate = "error")

j=954*(i-1)+1
j1=954*i
vwindinterpp8114a[j:j1,1]=call8114a$z
vwindinterpp8114a[j:j1,2]=wyele$Code

}

vwindinterpp8114b=vwindinterpp8114a[with(vwindinterpp8114a, order(vwindinterpp8114a[,2])), ]
vwindinterpp8114c=vwindinterpp8114b[,1]

save(vwindinterpp8114c,file='vwind_wy20614.RData')

rm(vwindinterpp8114a,vwindinterpp8114b,vwindinterpp8114c,call8114a,i,j,j1,lat8114a,lon8114a,wyallvwind8114,wyele,WYregcoast1,vwind8114,VWIND8114a,vwindall8114,x8114,y8114,yneg8114)



