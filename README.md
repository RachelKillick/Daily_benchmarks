# Daily_benchmarks

Thank you for taking the time to look at this project.

If you are interested in running the models with the exact inputs I used please look in the models subfolder - this has the exact model formulation and reference to the relevant data which you can find in the Data subfolder. 

In the Data subfolder you can find the code I used to thin the data to make the models less computationally intensive, but the full datasets are also available should you wish to do your own thinning, or no thinning at all. The Data subfolder also contains necessary files if you want to pick the project up at a later stage, for example before the spatial and/or temporal smoothing or immediately before the addition of inhomogeneities.

In the pre-processing folder you will find the code I used to interpolate the Southern Oscillation Index and the reanalysis fields (the data for these variables are in the Data subfolder). This allows you to do different interpolations should you choose to do so. However, note that the existing model formulation expects inputs at the daily station level.

Unfortnately the .RData files of the fitted models are too large to be uploaded, but I'm happy to provide them on request. This offer also applies to any other .RData files you feel would be useful as many of them are over the size limit for GitHub. In the post-processing folder you can find the code that adds and smooths Gamma noise.

Code used to corrupt the data is found in the Inhomogeneities folder.

Adapted code contains just a single file loesssurf1 - which was adapted from the inbuilt R loesssurf function to allow predictions to be made from it.

If you wish to just pick up the complete clean data and the complete corrupted data please go to https://www.metoffice.gov.uk/hadobs/benchmarks/.

Code used to evaluate the returned data can be found in the Evaluation folder. This code is an adaptation of that used to assess the Climatol contribution, but provided the data to be evaluated have a similar format it can be easily reused to evaluate any contribution.
