# From original code 'Cluster_scripts_coasts_and_thinning_ne_other.R', but with extraneous information removed.

library(mgcv)
load('necoastthinother.RData')

modelnecoast5gf3other=gam(TMEAN60~s(Time,k=3)+s(Dyear,uw)+s(Long)+s(Lat)+s(sun)+s(pwc)+s(vw)+s(prcpf)+tempf+s(slp100)+s(soinew)+s(Coast)+Altitude,data=necoastthinother,family=Gamma (link=identity),gamma=1.4)

save(modelnecoast5gf3other,file='modelnecoast5gf3other.RData')
rm(modelnecoast5gf3other)

