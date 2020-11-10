# This file contains the implementation of starma based on zip code study zones and its evaluation
# The process is repeated for each crime type:

# Create neighbors based on the study area
knb <- dnearneigh(my_sites_Bz, 0, 20000)  # radius can be changed (cases that examined: r=15800, r=16200 & r=20000)
knb <- nblag(knb, 4) #different number of neighbors are examined (cases that examined: n=2 (only for r=15800), n=3 & n=4)
klist <- list(order0=diag(248), # the number corresponds to the amount of study zones that used
              order1=nb2mat(knb[[1]]),
              order2=nb2mat(knb[[2]]),
              order3=nb2mat(knb[[3]]),
              order4=nb2mat(knb[[4]]))

# Normalize the data
all_norm<- stcenter(working_for_Zip_all) #for property type write "working_for_Zip_p" and for violent "working_for_Zip_v"

# Estimate the process
ar<-1 # Different scenarios are examined (ar=1 for scenarios 0 & 2 and ar=2 for scenarios 1 & 3)
ma<-2 # Different scenarios are examined (ma=1 for scenarios 0 & 1 and ma=2 for scenarios 2 & 3)
model <- starma(all_norm, klist, ar, ma)
model
summary(model)
model$residuals #residuals of the model
(max.print = 53) # because of 53 weeks

res_ok_all_0<-model$residuals
suma<-res_ok_all_0 + all_norm #calculation of propabilities based on real data values and their residuals

# The code below refers to its evaluation with PAI and Hit rate metrics
# Classify model
mystar <- data.frame(matrix(NA, nrow = 248, ncol = 53)) # create new empty dataframe
mystar<-as.data.frame(t(suma)) # transpose suma to get weeks as columns and polygons as rows
colnames(mystar) <- paste("week", 1:53, sep = "") #rename

mystarq<-data.frame(matrix(NA, nrow = 3, ncol = 53)) #making the table to classify values based on quantile classes
for (i in 1:53){
  colnames(mystarq) <- paste("week", 1:53, sep = "")
}

rownames(mystarq)[1]<-"Percentile_00"
rownames(mystarq)[2]<-"Percentile_80" #the fifth class
rownames(mystarq)[3]<-"Percentile_100"

for (i in 1:53){
  mystarq[1,i] = min(mystar[,i]) #it was for suma, but i try for mystar
  mystarq[2,i] = quantile(mystar[,i], 0.8) #get the top 20% of values
  mystarq[3,i] = max(mystar[,i])
} 

suma2<-suma #classify the initial outputs to 0 and 1
for (i in 1:53){
  for (j in 1:248){
    if (suma2[i,j] < mystarq[2,i]){
      suma2 [i,j] <- 0
    }
    else if (suma2[i,j] >= mystarq[2,i]){
      suma2 [i,j] <- 1
    }
  }
}

# Create a result file
real_all <- working_for_Zip_all #for property type write "working_for_Zip_p" and for violent "working_for_Zip_v"
colnames(real_all)[1] <- "83" #this information should be reset because the initial format is not numeric

for (i in 1:248){
  if (zip_area$ZIPCODE[i]==colnames(real_all[i])){ # a file with zip codes and their areas has been made "zip_area"
    real_all[1,i] <- zip_area$ZIPCODES_ZONES.SHAPE_AREA[i]
  }
}

# Calculation of PAI and HIT RATE indexes
Hotspot_star <- data.frame(matrix(0, nrow = 53, ncol = 4))
colnames(Hotspot_star)[1]<-"n" #number of crimes when a study zone is hotspot
colnames(Hotspot_star)[2]<-"N" #total number of crimes in the whole study area
colnames(Hotspot_star)[3]<-"a" #total area of hotspots
colnames(Hotspot_star)[4]<-"A" #total area of the whole study area

for (i in 1:53){
  for (j in 1:248){
    if (suma2[i,j]==1){
      Hotspot_star[i,1] <- Hotspot_star[i,1]+ sum(real_all[i,j])
      Hotspot_star[i,2] <- sum(real_all[i,])
      Hotspot_star[i,3] <- Hotspot_star[i,3]+ sum(real_all[1,j])
      Hotspot_star[i,4] <- sum(real_all[1,])
    }
  }
}

for (p in 1:53){
  Hotspot_star$PAI[p]<- (Hotspot_star[p,1]/Hotspot_star[p,2])/(Hotspot_star[p,3]/Hotspot_star[p,4])
}

Hotspot_star <- cbind(Week = rownames(Hotspot_star), Hotspot_star)
rownames(Hotspot_star) <- 1:nrow(Hotspot_star)

for (i in 1:53){
  Hotspot_star[i,7]<-Hotspot_star[i,2]*100/Hotspot_star[i,3]
}
colnames(Hotspot_star)[7]<-"Hit_rate"
Hotspot_star[1:2,c(2:7)]<-0 # the first two rows (two weeks) should be equal to zero because they are included for forecasting