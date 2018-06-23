# South West model taken from 'Cluster_script_coasts_and_thinning_sw.R':

library(mgcv)
load('swcoastthin1.RData')

modelswcoast5gf3th1=gam(TMEAN60~s(Time,k=3)+s(Dyear,uw)+s(Long)+s(Lat)+s(sun)+s(pwc)+s(vw)+s(prcpf)+tempf+s(slp100)+s(soinew)+s(Coast)+Altitude,data=swcoastthin1,family=Gamma (link=identity),gamma=1.4)

save(modelswcoast5gf3th1,file='modelswcoast5gf3th1.RData')
rm(modelswcoast5gf3th1)


