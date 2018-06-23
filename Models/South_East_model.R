# South East model:

library(mgcv)
load('secoastthin1.RData')

modelsecoast5gf3th1=gam(TMEAN60~s(Time,k=3)+s(Dyear,uw)+s(Long)+s(Lat)+s(sun)+s(pwc)+s(vw)+s(prcpf)+tempf+s(slp100)+s(soinew)+s(Coast)+Altitude,data=secoastthin1,family=Gamma(link=identity),gamma=1.4)

save(modelsecoast5gf3th1,file='modelsecoast5gf3th1.RData')
rm(modelsecoast5gf3th1)

