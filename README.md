# MScThesis_STARMA_Forecasting_Crime
Exploring Space-Time Autoregressive models to forecast crime

This repository was done under the MSc GIMA thesis purposes and it studies the performance of the STARMA (spatiotemporal autoregressive moving average) method in forecasting crimes based only on spatiotemporal crime data and compared to baseline methods.

-What are the other baseline methods?

-The other two baseline methods that the STARMA is compared with are a naive one and the Kernel Density Estimation, which even though it is not forecasting method but a simple interpolation one, it is popular used as forecasting from police forces to make patrols. The naive Baseline method is realized without any processing of original input data (real data from one week before) while the KDE method is implemented in ArcGIS once data has been transformed in a suitable form.



-From how long ago (tlag) are the using (past) crime data and in which temporal and spatial scale - resolution is it studied?

-The more recent data the more related to the study period. Once this thesis works with weekly data, a week before every time is an associated period to be based on. This study is based on zipcode areas (spatial resolution).  



-Under which methodology both of the using method will define a study zone as hotspot (area with high crime probability for the following week)?

-For both the three methods, data are classified to five Quantile classes and then the highest (fifth) class is defined as hotspot whereas the first four classes as non-hotspot. 



-Are the input crime incidents used as one crime type or they are divided into more than one types?

-The study examines three different crime types; all (as incidents), property (e.g. theft) and violent (e.g. rape).



-What is the study area and the study period?

-This study is applied for the whole area of the NYC (New York City) and for the recent 2016 year.



-What are the preprocessing steps in order to get suitable data to work with?

-The "file_1" contains the preprocessing steps that required in order to manage default data and transform it as input for both the KDE and also the STARMA methods. This preprocess consists of the following steps:

Step 1: Input data (study zipcode zones are included in a rar file while the crime incidents can be downloaded from the official government website of New York Police Department (NYPD).

Step 2: Selection of appropriate attributes 

Step 3: Selection of the study period

Step 4: Clear data

Step 5: Division of crimes to totally three types

Step 6: Extract information about temporal resolution

Step 7: Setting the appropriate Projected Coordinate Reference System (PCRS)

Step 8: Spatial Join 

Step 9: Summarizing the amount of crime incidents per study zones and per crime type

Step 10: Replace the N.A. (non-available) values with zero number of incidents

Step 11: Replacing of polygons with points regarding the geometry of study zones

Step 12*: Make separate files for each type crime

Step 13*: Transposition of data in order to have "weeks" as rows and "zipcodes" as columns

Step 14*: Extract information for study zones' geometry .

(processes with * refer only to starma model). 



-Under which evaluation performance metrics are the applied methods being evaluated?

-The "file_2" contains the implementation and evaluation process which is done through suitable performance metrics (Hit rate, PAI) of the STARMA method. The following steps are included:
Step 1: Create neighbors based on the study area: each polygon (study zone) is affected by their 2,3 or 4 neighbors in forecasting.
Step 2: Normalize the data: data should be standard normalized (mean = 0, st. deviaton =1).
Step 3: Estimate the process (get residuals).
Step 4: Classify model: study zones are classified to hotspots (1) or non-hotspots (0) based on a threshold value and once the data have been classified into 5 quantile classes. The threshold value defines the fifth class every time.
Step 5: Evaluation of performance through two widely used metrics (PAI & Hit rate)



-What about the evaluation of two baseline methods?

-The "file_3" contains the using code for evaluation both KDE and naive Baseline method. The process is done for 52 weeks (one year) and for each crime type.
