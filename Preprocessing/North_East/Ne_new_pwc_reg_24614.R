# This document is an update of the 2114 documents in an attempt to speed up my interpolation process!

# First load all the packages which might be helpful:

library(ncdf)
library(ncdf4)
library(akima)
library(fields)

# Now read in the data:

neallpwc8114 <- open.ncdf('pwc_ne2114.nc') # This should forecasted eastward wind data on 2x2 (approx.) grid squares for -82 to -66 (278 to 294) longitude and 40 to 50 latitude

x8114 <- get.var.ncdf(neallpwc8114, "lat")          # coordinate variable = (50.4752 - got rid of) 48.5705 46.6658 44.7611 42.8564 40.9517 39.0470 
y8114 <- get.var.ncdf(neallpwc8114, "lon")          #  coordinate variable = (277.500 - got rid of) 279.375 281.250 283.125 285.000 286.875 288.750 290.625 292.500 294.375 - I had a quick look at leaving my bracketed values in just choosing 4 random values of i and they didn't seem to change the interpolated values - or at least only by computational error amounts like 1e-16 up to 1e-14 (looking at the difference between call2114$z and call2114a$z)
yneg8114 <- y8114-360				 # Currently the longitudes are between 0 and 360, I want my longitudes here to match the longitudes from the GHCND data => by subtracting 360 I make them match (I hope!)

pwcall8114 <- get.var.ncdf(neallpwc8114) 	         # SLP for each day from 1st January 1970 to 31st December 2011 - a matrix with 6 columns and 9 rows 

# Useful for table later on in code:

lat8114a=cbind(c(rep(39.0470,9),rep(40.9517,9),rep(42.8564,9),rep(44.7611,9),rep(46.6658,9),rep(48.5705,9)))
lon8114a=cbind(c(rep(yneg8114,6)))

# Create a data frame for my info to be stored in

pwcinterpp8114a=data.frame(matrix(ncol=2,nrow=19328400))

# Read in my station information

load('/scratch/rw307/Reading/Scripts/NorthEast/NEregcoast1.RData')

neele=NEregcoast1
names(neele)=c('Code','Lat','Long','Elevation')
neele$Code=seq(1,1260)

# Now I want a loop so I can look at all 15340 days without having to change anything manually

i=1 

for (i in 1:15340) {

# Read in the data

pwc8114=pwcall8114[,,i]

PWC8114a=cbind(c(pwc8114[,6],pwc8114[,5],pwc8114[,4],pwc8114[,3],pwc8114[,2],pwc8114[,1]))
call8114a=interpp(lat8114a,lon8114a,PWC8114a,neele$Lat,neele$Long, linear=TRUE, extrap=FALSE, duplicate = "error")

j=1260*(i-1)+1
j1=1260*i
pwcinterpp8114a[j:j1,1]=call8114a$z
pwcinterpp8114a[j:j1,2]=neele$Code

}

pwcinterpp8114b=pwcinterpp8114a[with(pwcinterpp8114a, order(pwcinterpp8114a[,2])), ]
pwcinterpp8114c=pwcinterpp8114b[,1]

save(pwcinterpp8114c,file='pwc_ne24614.RData')


rm(pwcinterpp8114a,pwcinterpp8114b,pwcinterpp8114c,call8114a,i,j,j1,lat8114a,lon8114a,neallpwc8114,neele,NEregcoast1,pwc8114,PWC8114a,pwcall8114,x8114,y8114,yneg8114)



