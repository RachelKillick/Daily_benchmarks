# Wyoming model (taken from Cluster_script_wyoming_models_rerun_because_of_coast_10714.R:

library(mgcv)
load('wycoastthin1n.RData')

modelwycoast5gf3th1n=gam(TMEAN60~s(Time,k=3)+s(Dyear,uw)+s(Long)+s(Lat)+s(sun)+s(pwc)+s(vw)+s(prcpf)+tempf+s(slp100)+s(soinew)+s(Coast)+Altitude,data=wycoastthin1n,family=Gamma(link=identity),gamma=1.4)

save(modelwycoast5gf3th1n,file='modelwycoast5gf3th1nnotcluster.RData')
rm(modelwycoast5gf3th1n)
