# Hopefully verging on my final model in the Northeast:

# Load the necessary packages first:

library(mgcv)
library(akima)
library(fields)

# Load the necessary dataframes and other R things:

load('modelnecoast5gf3other.RData') 
load('loesssurf1.RData') 
load('NEcoast1relocor_1714.RData') 

# Create my predictions - Allow 1Gb:

pred5other=predict.gam(modelnecoast5gf3other,newdata=NEcoast1relocor,type="response")

save(pred5other,file='pred5other_full_small.RData')

# Add the gamma noise onto my predictions:

# Step 1: Create the data frames to store the info in:

pred5othergam=as.data.frame(matrix(nrow=4540640,ncol=1))

# Step 2: Get the shape parameter (for each model this will be the same for all predictions):

shmodel5other=1/modelnecoast5gf3other$sig2

# Step3: Generate the new predictions with gamma noise:

i=1

while (i< 4540641) {

mnmodel5other=pred5other[i]

scmodel5other=mnmodel5other/shmodel5other

pred5othergam[i,1]=rgamma(1,shape=shmodel5other,scale=scmodel5other)

i=i+1

}

save(pred5other,pred5othergam,file='preds_ne_11714_relocation_full_smaller.RData')


