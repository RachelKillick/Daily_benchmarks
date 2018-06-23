# This document is an update of the 2114 documents in an attempt to speed up my interpolation process!

# First load all the packages which might be helpful:

library(ncdf)
library(ncdf4)
library(akima)
library(fields)

# Now read in the data:

wyallslp8114 <- open.ncdf('/scratch/rw307/USA/QualityControlled/Wyoming_all.nc') # This should be sea level pressure data on 2x2 grid squares for -82 to -66 (278 to 294) longitude and 40 to 50 latitude

x8114 <- get.var.ncdf(wyallslp8114, "lat")          # coordinate variable = 46 44 42 40
y8114 <- get.var.ncdf(wyallslp8114, "lon")          # coordinate variable = 246 248 250 252 254 256 258 260
yneg8114 <- y8114-360				 
slpall8114 <- get.var.ncdf(wyallslp8114) 	    # A matrix with 4 columns and 8 rows

# Useful for table later on in code:

lat8114a=cbind(c(rep(40,8),rep(42,8),rep(44,8),rep(46,8)))
lon8114a=cbind(c(rep(yneg8114,4)))

# Create a data frame for my info to be stored in

slpinterpp8114a=data.frame(matrix(ncol=2,nrow=14634360))

# Read in my station information

load('/scratch/rw307/Reading/Scripts/Wyoming_new/WYregcoast1.RData')

wyele=WYregcoast1
names(wyele)=c('Code','Lat','Long','Elevation')
wyele$Code=seq(1,954)

# Now I want a loop so I can look at all 15340 days without having to change anything manually

i=1 

for (i in 1:15340) {

# Read in the data

slp8114=slpall8114[,,i]
SLP8114a=cbind(c(slp8114[,4],slp8114[,3],slp8114[,2],slp8114[,1]))
call8114a=interpp(lat8114a,lon8114a,SLP8114a,wyele$Lat,wyele$Long, linear=TRUE, extrap=FALSE, duplicate = "error")

j=954*(i-1)+1
j1=954*i
slpinterpp8114a[j:j1,1]=call8114a$z
slpinterpp8114a[j:j1,2]=wyele$Code

}

slpinterpp8114b=slpinterpp8114a[with(slpinterpp8114a, order(slpinterpp8114a[,2])), ]
slpinterpp8114c=slpinterpp8114b[,1]

save(slpinterpp8114c,file='slp_wy20614.RData')

rm(slpinterpp8114a,slpinterpp8114b,slpinterpp8114c,call8114a,i,j,j1,lat8114a,lon8114a,wyallslp8114,wyele,WYregcoast1,slp8114,SLP8114a,slpall8114,x8114,y8114,yneg8114)



