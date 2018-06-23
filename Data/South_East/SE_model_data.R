# From 'Distance_to_coast_modelling_SE.R'

# Load the non-thinned dataset:

load('secoastlattime.RData')

# Now thin this dataset - taking every other day:

secoastthin1=secoastlattime[-(seq(0,2377700,2)),]

save(secoastthin1,file='secoastthin1.RData')




