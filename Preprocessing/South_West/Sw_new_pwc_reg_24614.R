# This document is an update of the 2114 documents in an attempt to speed up my interpolation process!

# First load all the packages which might be helpful:

library(ncdf)
library(ncdf4)
library(akima)
library(fields)

# Now read in the data:

swallpwc8114 <- open.ncdf('pwc_sw2114.nc') # This should be sea level pressure data on 2x2 grid squares for -82 to -66 (278 to 294) longitude and 40 to 50 latitude

x8114 <- get.var.ncdf(swallpwc8114, "lat")          # coordinate variable = 40.9517 39.0470 37.1422 35.2375 33.3328 31.4281 (29.5234 - got rid of)
y8114 <- get.var.ncdf(swallpwc8114, "lon")          #  coordinate variable = (234.375 - got rid of) 236.250 238.125 240.000 241.875 243.750 245.625 247.500 (249.375 - got rid of)
yneg8114 <- y8114-360				 # Currently the longitudes are between 0 and 360, I want my longitudes here to match the longitudes from the GHCND data => by subtracting 360 I make them match (I hope!)

pwcall8114 <- get.var.ncdf(swallpwc8114) 	         # PWC for each day from 1st January 1970 to 31st December 2011 - a matrix with 6 columns and 7 rows 

# Useful for table later on in code:

lat8114a=cbind(c(rep(31.4281,7),rep(33.3328,7),rep(35.2375,7),rep(37.1422,7),rep(39.0470,7),rep(40.9517,7)))
lon8114a=cbind(c(rep(yneg8114,6)))

# Create a data frame for my info to be stored in

pwcinterpp8114a=data.frame(matrix(ncol=2,nrow=21169200))

# Read in my station information

load('/scratch/rw307/Reading/Scripts/SouthWest/SWregcoast1.RData')

swele=SWregcoast1
names(swele)=c('Code','Lat','Long','Elevation')
swele$Code=seq(1,1380)

# Now I want a loop so I can look at all 15340 days without having to change anything manually

i=1 

for (i in 1:15340) {

# Read in the data

pwc8114=pwcall8114[,,i]
PWC8114a=cbind(c(pwc8114[,6],pwc8114[,5],pwc8114[,4],pwc8114[,3],pwc8114[,2],pwc8114[,1]))
call8114a=interpp(lat8114a,lon8114a,PWC8114a,swele$Lat,swele$Long, linear=TRUE, extrap=FALSE, duplicate = "error")

j=1380*(i-1)+1
j1=1380*i
pwcinterpp8114a[j:j1,1]=call8114a$z
pwcinterpp8114a[j:j1,2]=swele$Code

}

pwcinterpp8114b=pwcinterpp8114a[with(pwcinterpp8114a, order(pwcinterpp8114a[,2])), ]
pwcinterpp8114c=pwcinterpp8114b[,1]

save(pwcinterpp8114c,file='pwc_sw24614.RData')

rm(pwcinterpp8114a,pwcinterpp8114b,pwcinterpp8114c,call8114a,i,j,j1,lat8114a,lon8114a,swallpwc8114,swele,SWregcoast1,pwc8114,PWC8114a,pwcall8114,x8114,y8114,yneg8114)



