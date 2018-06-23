# This cluster script needs to have all the information it could need in this document so that it doesn't crash at any time - the values by some things are approximations of how much memory they take - I think some of the steps could be HUGE - so I'll try it with a 16GB limit (as that's not unreasonable) and see how far it gets before it crashes - if it does crash at all - if it uses the memory too quickly I'll have to run the prediction code separately for the separate models in which case I should probably prioritise only the models I REALLY need to look at:

# Load the necessary packages first:

library(mgcv)
library(akima)
library(fields)

# Load the necessary dataframes and other R things :

load('loesssurf1.RData') 
load('WYcoast1relocor_30614.RData') 
load('modelwycoast5gf3th1nnotcluster.RData')

# Create my predictions - Allow 1Gb:

pred5th1all=predict.gam(modelwycoast5gf3th1n,newdata=WYcoast1relocor,type="response")

save(pred5th1all,file='pred5th1all_wy_full_small.RData')

# If starting from here can just do:
load('pred5th1all_wy_full_small.RData')

# Add the gamma noise onto my predictions:

# Step 1: Create the data frames to store the info in:

pred5th1gam=as.data.frame(matrix(nrow=2301000,ncol=1))

# Step 2: Get the shape parameter (for each model this will be the same for all predictions):

shmodel5th1=1/modelwycoast5gf3th1n$sig2

# Step3: Generate the new predictions with gamma noise:

i=1

while (i< 2301001) {

mnmodel5th1=pred5th1all[i]

scmodel5th1=mnmodel5th1/shmodel5th1

pred5th1gam[i,1]=rgamma(1,shape=shmodel5th1,scale=scmodel5th1)

i=i+1

}

save(pred5th1all,pred5th1gam,file='preds_wy_with_relocations_full_smaller_11714.RData')




