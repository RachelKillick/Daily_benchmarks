# Hopefully verging on my final model in the Northeast:

# Load the necessary packages first:

library(mgcv)
library(akima)
library(fields)

# Load the necessary dataframes and other R things:

load('modelnecoast5gf3other.RData') 
load('loesssurf1.RData') 
load('NEcoast1reloc_1714.RData') 

# Create my predictions - Allow 1Gb:

pred5other=predict.gam(modelnecoast5gf3other,newdata=NEcoast1reloc,type="response")

save(pred5other,file='pred5other_full_denser.RData')

# Add the gamma noise onto my predictions:

# Step 1: Create the data frames to store the info in:

pred5othergama=as.data.frame(matrix(nrow=6442800,ncol=1))
pred5othergamb=as.data.frame(matrix(nrow=6442800,ncol=1))

# Step 2: Get the shape parameter (for each model this will be the same for all predictions):

shmodel5other=1/modelnecoast5gf3other$sig2

# Step3: Generate the new predictions with gamma noise:

i=1

while (i< 6442801) {

mnmodel5other=pred5other[i]

scmodel5other=mnmodel5other/shmodel5other

pred5othergama[i,1]=rgamma(1,shape=shmodel5other,scale=scmodel5other)
pred5othergamb[i,1]=rgamma(1,shape=shmodel5other,scale=scmodel5other)

i=i+1

}

save(pred5other,pred5othergama,pred5othergamb,file='preds_ne_11714_relocation_full_denser.RData')


