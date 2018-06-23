# Hopefully verging on my final model for SE

# Load the necessary packages first:

library(mgcv)
library(akima)
library(fields)

# Load the necessary dataframes and other R things:

load('modelsecoast5gf3th1.RData') 
load('loesssurf1.RData') 
load('SEcoast1relocor_1714.RData') 

# Create my predictions - Allow 1Gb:

pred5th1=predict.gam(modelsecoast5gf3th1,newdata=SEcoast1relocor,type="response")

save(pred5th1,file='pred5th1_se_full_smaller.RData')

# Add the gamma noise onto my predictions:

# Step 1: Create the data frames to store the info in:

pred5th1gam=as.data.frame(matrix(nrow=4755400,ncol=1))

# Step 2: Get the shape parameter (for each model this will be the same for all predictions):

shmodel5th1=1/modelsecoast5gf3th1$sig2

# Step3: Generate the new predictions with gamma noise:

i=1

while (i< 4755401) {

mnmodel5th1=pred5th1[i]

scmodel5th1=mnmodel5th1/shmodel5th1

pred5th1gam[i,1]=rgamma(1,shape=shmodel5th1,scale=scmodel5th1)

i=i+1

}

save(pred5th1,pred5th1gam,file='preds_se_11714_smaller_full.RData')





