# The evaluation of the KDE is based on outputs from ArcGIS and more particularly the model builder process.
# The following script is repeated 52 times 
#for (XX in 2:53)
kde_trueXX<-as.data.frame(matrix(0,248,7))
for (i in XX:XX) {
  filename <- sprintf("C:\\MODULE_7FINAL\\kde\\zip_results_all_p_v\\all\\allforw%d",i) #this is the path of datasets 
  forecastkde <- read.csv(filename, header = TRUE, sep = ",", dec = ".")
  filename2 <- sprintf("C:\\MODULE_7FINAL\\kde\\zip_results_all_p_v\\all\\week%d",i)   #this is the path of datasets 
  realkde <- read.csv(filename2, header = TRUE, sep = ",", dec = ".")
  
  kde_trueXX[,1]<-realkde$XCoord
  kde_trueXX[,2]<-realkde$YCoord
  kde_trueXX[,3]<-realkde$ZIPCODE
  kde_trueXX[,4]<-forecastkde$ZIPCODES_ZONES.SHAPE_AREA
  kde_trueXX[,5]<-realkde[,4]
  kde_trueXX[,6]<-forecastkde[,5]
  kde_trueXX[,7]<-realkde$WK
}
for (i in 1:248){
  kde_trueXX[i,8]<-BZ_def_geo$geometry[i]
}

# After 52 times, all the files are binded
kde_outputs_all<-rbind(kde_true2,kde_true3,kde_true4,kde_true5,kde_true6,kde_true7,kde_true8,kde_true9,kde_true10,kde_true11,
                       kde_true12,kde_true13,kde_true14,kde_true15,kde_true16,kde_true17,kde_true18,kde_true19,kde_true20,kde_true21,
                       kde_true22,kde_true23,kde_true24,kde_true25,kde_true26,kde_true27,kde_true28,kde_true29,kde_true30,kde_true31,
                       kde_true32,kde_true33,kde_true34,kde_true35,kde_true36,kde_true37,kde_true38,kde_true39,kde_true40,kde_true41,
                       kde_true42,kde_true43,kde_true44,kde_true45,kde_true46,kde_true47,kde_true48,kde_true49,kde_true50,kde_true51,
                       kde_true52,kde_true53)

# Columns get appropriate names
colnames(kde_outputs_all)[1]<-"X"
colnames(kde_outputs_all)[2]<-"Y"
colnames(kde_outputs_all)[3]<-"ZIPCODE"
colnames(kde_outputs_all)[4]<-"AREA"
colnames(kde_outputs_all)[5]<-"CRIMES"
colnames(kde_outputs_all)[6]<-"FORECAST_HOTSPOT"
colnames(kde_outputs_all)[7]<-"WEEK"
colnames(kde_outputs_all)[8]<-"geometry"

# Assumption that NULL values of KDE outputs are "non-hotspot" areas
sizef <- nrow (kde_outputs_all)
for (k in 1:sizef){
  if (kde_outputs_all[k, 6]=="NULL"){
    kde_outputs_all[k, 6] = 0
  }
}
kde_outputs_all[,6]<- droplevels(kde_outputs_all[,6]) 

a=0
N=0
n=0
for (i in 1:12896){
  if (kde_outputs_all$WEEK[i]==XX){
    N=N+sum(kde_outputs_all$CRIMES[i])
    if (kde_outputs_all$FORECAST_HOTSPOT[i]==1){
      n=n+sum(kde_outputs_all$CRIMES[i])
      a=a+sum(kde_outputs_all$AREA[i])
    }
  }
}

# the process is repeated for each type crime-------------------------
#---------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------

#---------------------------------------------------------------------------------------
#---------------------------------------------------------------------------------------
# The evaluation of the baseline method is based on output files, which created manually from real data.
# The following script is repeated 52 times 
#for (XX in 2:53)
baseline_trueXX<-as.data.frame(matrix(0,248,7))
for (i in 2:2) {
  filename <- sprintf("C:\\MODULE_7FINAL\\zip_baseline\\all\\allforw%d",i)
  forecastb <- read.csv(filename, header = TRUE, sep = ",", dec = ".")
  filename2 <- sprintf("C:\\MODULE_7FINAL\\zip_baseline\\all\\week%d",i)
  realb <- read.csv(filename2, header = TRUE, sep = ",", dec = ".")
  
  baseline_trueXX[,1]<-realb$XCoord
  baseline_trueXX[,2]<-realb$YCoord
  baseline_trueXX[,3]<-realb$ZIPCODE
  baseline_trueXX[,4]<-zip_area$ZIPCODES_ZONES.SHAPE_AREA
  baseline_trueXX[,5]<-realb[,4]
  baseline_trueXX[,6]<-forecastb[,4]
  baseline_trueXX[,7]<-realb$WK
  
  colnames(baseline_trueXX)[1]<-"X"
  colnames(baseline_trueXX)[2]<-"Y"
  colnames(baseline_trueXX)[3]<-"ZIPCODE"
  colnames(baseline_trueXX)[4]<-"AREA"
  colnames(baseline_trueXX)[5]<-"CRIMES"
  colnames(baseline_trueXX)[6]<-"FORECAST_HOTSPOT"
  colnames(baseline_trueXX)[7]<-"WEEK"
}

# After 52 times, all the files are binded
baseline_outputs_all<-rbind(baseline_true2,baseline_true3,baseline_true4,baseline_true5,baseline_true6,baseline_true7,baseline_true8,baseline_true9,baseline_true10,baseline_true11,
                            baseline_true12,baseline_true13,baseline_true14,baseline_true15,baseline_true16,baseline_true17,baseline_true18,baseline_true19,baseline_true20,baseline_true21,
                            baseline_true22,baseline_true23,baseline_true24,baseline_true25,baseline_true26,baseline_true27,baseline_true28,baseline_true29,baseline_true30,baseline_true31,
                            baseline_true32,baseline_true33,baseline_true34,baseline_true35,baseline_true36,baseline_true37,baseline_true38,baseline_true39,baseline_true40,baseline_true41,
                            baseline_true42,baseline_true43,baseline_true44,baseline_true45,baseline_true46,baseline_true47,baseline_true48,baseline_true49,baseline_true50,baseline_true51,
                            baseline_true52,baseline_true53)

Percentile_00  = min(baseline_outputs_all[,6])
Percentile_5th  = quantile(baseline_outputs_all[,6], 0.8) #classification based on quantile classes
Percentile_100 = max(baseline_outputs_all[,6])

baseline_outputs_all[,6][baseline_outputs_all[,6] >= Percentile_00 & baseline_outputs_all[,6] <  Percentile_5th]  = 0
baseline_outputs_all[,6][baseline_outputs_all[,6] >= Percentile_5th & baseline_outputs_all[,6] <= Percentile_100] = 1

k=XX
a_all=0
N_all=0
nall=0
for (i in 1:12896){
  if (baseline_outputs_all$WEEK[i]==k){
    N_all=N_all+sum(baseline_outputs_all$CRIMES[i])
    if (baseline_outputs_all$FORECAST_HOTSPOT[i]==1){
      nall=nall+sum(baseline_outputs_all$CRIMES[i])
      a_all=a_all+sum(baseline_outputs_all$AREA[i])
    }
  }
}
# the process is repeated for each type crime-------------------------