# Creating the thinned dataset for the North East for model building - code the slimmed down version of 'Distance_to_coast_modelling_NE.R':

load('necoastlattimenolakes.RData') # necoastlattimenolakes is the data frame of interest.

# Take every other day at every other station:

necoastlatstatnolakes=necoastlattimenolakes[with(necoastlattimenolakes,order(Station)),]

necoastlessnolakes=necoastlatstatnolakes[necoastlatstatnolakes$Year != 2011 | necoastlatstatnolakes$Month != 12 | necoastlatstatnolakes$Day != 31, ]

necoastthinother=necoastlessnolakes[-seq(0,2270172,2),] 

save(necoastthinother,file='necoastthinother.RData')

