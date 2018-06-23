# This cluster script is the beginning of an attempts to establish which model should be used for modelling mean temperatures in the South East - I am just doing the testing on the last 11 years of data (the same period as in Wyoming) to make the process quicker

# Load the necessary packages first:

library(mgcv)
library(akima)
library(fields)

# Load the necessary dataframes and other R things:

load('modelswcoast5gf3th1.RData')
load('loesssurf1.RData') 
load('SWcoast1relocor_1714.RData') 

# Create my predictions - Allow 1Gb:

preds5th1=predict.gam(modelswcoast5gf3th1,newdata=SWcoast1relocor,type="response")

save(preds5th1,file='preds5th1_full_smaller_sw.RData')

# Add the gamma noise onto my predictions:

# Step 1: Create the data frames to store the info in:

preds5th1gam=as.data.frame(matrix(nrow=4816760,ncol=1))

# Step 2: Get the shape parameter (for each model this will be the same for all predictions):

shmodel5th1=1/modelswcoast5gf3th1$sig2

# Step3: Generate the new predictions with gamma noise:

i=1

while (i< 4816761) {

mnmodel5th1=preds5th1[i]

scmodel5th1=mnmodel5th1/shmodel5th1

preds5th1gam[i,1]=rgamma(1,shape=shmodel5th1,scale=scmodel5th1)

i=i+1

}

save(preds5th1,preds5th1gam,file='preds_sw_comp_11714_relocations_full_smaller.RData')

