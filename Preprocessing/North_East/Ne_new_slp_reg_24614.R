# This document is an update of the 2114 documents in an attempt to speed up my interpolation process!

# First load all the packages which might be helpful:

library(ncdf)
library(ncdf4)
library(akima)
library(fields)

# Now read in the data:

neallslp8114 <- open.ncdf('slp_ne2114.nc') # This should slp data on 2x2 (approx.) grid squares for -82 to -66 (278 to 294) longitude and 40 to 50 latitude

x8114 <- get.var.ncdf(neallslp8114, "lat")          # coordinate variable = 50 48 46 44 42 40
y8114 <- get.var.ncdf(neallslp8114, "lon")          #  coordinate variable = 278 280 282 284 286 288 290 292 294
yneg8114 <- y8114-360				 # Currently the longitudes are between 0 and 360, I want my longitudes here to match the longitudes from the GHCND data => by subtracting 360 I make them match (I hope!)

slpall8114 <- get.var.ncdf(neallslp8114) 	         # SLP for each day from 1st January 1970 to 31st December 2011 - a matrix with 6 columns and 9 rows 

# Useful for table later on in code:

lat8114a=cbind(c(rep(40,9),rep(42,9),rep(44,9),rep(46,9),rep(48,9),rep(50,9)))
lon8114a=cbind(c(rep(yneg8114,6)))

# Create a data frame for my info to be stored in

slpinterpp8114a=data.frame(matrix(ncol=2,nrow=19328400))

# Read in my station information

load('/scratch/rw307/Reading/Scripts/NorthEast/NEregcoast1.RData')

neele=NEregcoast1
names(neele)=c('Code','Lat','Long','Elevation')
neele$Code=seq(1,1260)

# Now I want a loop so I can look at all 15340 days without having to change anything manually

i=1 

for (i in 1:15340) {

# Read in the data

slp8114=slpall8114[,,i]

SLP8114a=cbind(c(slp8114[,6],slp8114[,5],slp8114[,4],slp8114[,3],slp8114[,2],slp8114[,1]))
call8114a=interpp(lat8114a,lon8114a,SLP8114a,neele$Lat,neele$Long, linear=TRUE, extrap=FALSE, duplicate = "error")

j=1260*(i-1)+1
j1=1260*i
slpinterpp8114a[j:j1,1]=call8114a$z
slpinterpp8114a[j:j1,2]=neele$Code

}

slpinterpp8114b=slpinterpp8114a[with(slpinterpp8114a, order(slpinterpp8114a[,2])), ]
slpinterpp8114c=slpinterpp8114b[,1]

save(slpinterpp8114c,file='slp_ne24614.RData')

rm(slpinterpp8114a,slpinterpp8114b,slpinterpp8114c,call8114a,i,j,j1,lat8114a,lon8114a,neallslp8114,neele,NEregcoast1,slp8114,SLP8114a,slpall8114,x8114,y8114,yneg8114)



