# Data for the South West model, taken from Distance_to_coast_modelling.R:

load('swcoastlattime.RData')

# Now thin this dataset:

swcoastthin1=swcoastlattime[-(seq(0,2408380,2)),]

save(swcoastthin1,file='swcoastthin1.RData')

