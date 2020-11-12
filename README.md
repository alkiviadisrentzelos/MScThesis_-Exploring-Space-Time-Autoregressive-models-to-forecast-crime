# MScThesis_STARMA_Forecasting_Crime
Exploring Space-Time Autoregressive models to forecast crime [GIMA master]

This repository was done under the MSc GIMA thesis purposes and it studies the performance of the STARMA method in forecasting crimes based on spatiotemporal crime data and compared to baseline methods (a naive basseline and Kernel Density Estimation). The forecasting is based on zipcode areas (spatial resolution) and on one week before crime data (temporal resolution). The naive Baseline method is realized without any processing of original input data (real data from one week before) while the KDE method is implemented in ArcGIS once data has been transformed in a suitable form. 

For both the three methods data are classified to five Quantile classes and then the highest (fifth) class is defined as hotspot whereas the first four classes as non-hotspot.
Lastly, the three methods are applied for three different crime types for the whole area of the NYC (New York City). To be noted: the code needs original paths and correct values instead of "XX" to run. This symbol is used for general guidance. 

The repository consists of 3 main files:

The file_1 contains the preprocessing steps that required in order to manage default data and transform it as input for both the KDE and also the STARMA methods. This preprocess consists of the following steps:
# Step 1: Input data (study zipcode zones are included in a rar file while the crime incidents can be downloaded from the official government website of New York Police Department (NYPD).
# Step 2: Selection of appropriate attributes 
# Step 3: Selection of the study period
# Step 4: Clear data
# Step 5: Division of crimes to totally three types
# Step 6: Extract information about temporal resolution
# Step 7: Setting the appropriate Projected Coordinate Reference System (PCRS)
# Step 8: Spatial Join 
# Step 9: Summarizing the amount of crime incidents per study zones and per crime type
# Step 10: Replace the N.A. (non-available) values with zero number of incidents
# Step 11: Replacing of polygons with points regarding the geometry of study zones
# Step 12*: Make separate files for each type crime
# Step 13*: Transposition of data in order to have "weeks" as rows and "zipcodes" as columns
# Step 14*: Extract information for study zones' geometry .
(processes with * refer only to starma model). 

The file_2 contains the implementation and evaluation through performance metrics (Hit rate, PAI) of the STARMA method. The following steps are included:
# Create neighbors based on the study area: each polygon (study zone) is affected by their 2,3 or 4 neighbors in forecasting.
# Normalize the data: data should be standard normalized (mean = 0, st. deviaton =1).
# Estimate the process (get residuals).
# Classify model: study zones are classified to hotspots (1) or non-hotspots (0) based on a threshold value and once the data have been classified into 5 quantile classes. The threshold value defines the fifth class every time.
# Evaluation of performance through two widely used metrics (PAI & Hit rate)

The file_3 contains the using code for evaluation both KDE and naive Baseline method. The process is done for 52 weeks (one year) and for each crime type.
