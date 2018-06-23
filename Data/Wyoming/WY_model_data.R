# Taken from Re_creating_Wyoming_coast_datasets_10714.R

# Load the full dataset:

load('/scratch/rw307/Reading/Scripts/Wyoming_new/wycoast.RData')

# Thin the dataset by taking every other day:

wycoastthin1n=WYcoastnew[-seq(0,1150500,2),]

save(wycoastthin1n,file='wycoastthin1n.RData') 


