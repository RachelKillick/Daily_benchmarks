# This document is an update of the 2114 documents in an attempt to speed up my interpolation process!

# First load all the packages which might be helpful:

library(ncdf)
library(ncdf4)
library(akima)
library(fields)

# Now read in the data:

wyallprcpf8114 <- open.ncdf('/scratch/rw307/For_running_scripts/Wyoming_prcpf.nc' ) # This should be sea level pressure data on 2x2 grid squares for -82 to -66 (278 to 294) longitude and 40 to 50 latitude

x8114 <- get.var.ncdf(wyallprcpf8114, "lat")          # coordinate variable = 46.6658 44.7611 42.8564 40.9517
y8114 <- get.var.ncdf(wyallprcpf8114, "lon")          # coordinate variable = 247.500 249.375 251.250 253.125 255.000 256.875 258.750
yneg8114 <- y8114-360				 
prcpfall8114 <- get.var.ncdf(wyallprcpf8114) 	    # A matrix with 4 columns and 7 rows

# Useful for table later on in code:

lat8114a=cbind(c(rep(40.9517,7),rep(42.8564,7),rep(44.7611,7),rep(46.6658,7)))
lon8114a=cbind(c(rep(yneg8114,4)))

# Create a data frame for my info to be stored in

prcpfinterpp8114a=data.frame(matrix(ncol=2,nrow=14634360))

# Read in my station information

load('/scratch/rw307/Reading/Scripts/Wyoming_new/WYregcoast1.RData')

wyele=WYregcoast1
names(wyele)=c('Code','Lat','Long','Elevation')
wyele$Code=seq(1,954)

# Now I want a loop so I can look at all 15340 days without having to change anything manually

i=1 

for (i in 1:15340) {

# Read in the data

prcpf8114=prcpfall8114[,,i]
PRCPF8114a=cbind(c(prcpf8114[,4],prcpf8114[,3],prcpf8114[,2],prcpf8114[,1]))
call8114a=interpp(lat8114a,lon8114a,PRCPF8114a,wyele$Lat,wyele$Long, linear=TRUE, extrap=FALSE, duplicate = "error")

j=954*(i-1)+1
j1=954*i
prcpfinterpp8114a[j:j1,1]=call8114a$z
prcpfinterpp8114a[j:j1,2]=wyele$Code

}

prcpfinterpp8114b=prcpfinterpp8114a[with(prcpfinterpp8114a, order(prcpfinterpp8114a[,2])), ]
prcpfinterpp8114c=prcpfinterpp8114b[,1]

save(prcpfinterpp8114c,file='prcpf_wy20614.RData')

rm(prcpfinterpp8114a,prcpfinterpp8114b,prcpfinterpp8114c,call8114a,i,j,j1,lat8114a,lon8114a,wyallprcpf8114,wyele,WYregcoast1,prcpf8114,PRCPF8114a,prcpfall8114,x8114,y8114,yneg8114)



