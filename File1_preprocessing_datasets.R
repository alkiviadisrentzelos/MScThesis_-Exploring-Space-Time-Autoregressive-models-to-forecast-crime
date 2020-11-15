#### Libraries ####
library(readxl)
library(here)
library(dplyr)
library(viridis)
library(ggplot2)
library(USAboundaries)
library(rnaturalearth)
library(GSODR)
library(ggrepel)
library(cowplot)
library(lubridate)
library(purrr)
library(tidyverse)
library(sf)
library(COUNT)
library(starma) 
library(spdep) 

# Step 1: Input data
defc<-read_excel(choose.files()) #the chosen file is named "Default.xlsx" (Default2016) for crime incidents
defz<-read_sf(choose.files()) #the chosen file should be as shape file (".shp"), this refers to zip codes as study zones

# Step 2: Selection of appropriate attributes 
cr1<-defc %>% select(ARREST_DATE, OFNS_DESC, ARREST_BORO, JURISDICTION_CODE, X_COORD_CD, Y_COORD_CD) 
zp1<-defz[,c(1,5,13)]# selection of useful attributes (at least zipcode id, area and their geometry)

# Step 3: Selection of the study period
startdate <- readline(prompt="Enter start date(YYYY-MM-DD): ")   #"2016-01-01"
enddate <- readline(prompt="Enter end date(YYYY-MM-DD): ")       #"2017-01-01"
cr1a<-cr1 %>% filter(cr1$ARREST_DATE >= startdate)  
cr2<-cr1a %>% filter(cr1a$ARREST_DATE <= enddate)  # it refers to year 2016

# Step 4: Clear data
test3a<-cr2
size3a<-nrow(test3a[,2])
test3b<-test3a[-which(is.na(test3a$OFNS_DESC)),] # delete empty rows
cr3<-test3b[(!(test3b$OFNS_DESC=="F.C.A. P.I.N.O.S.")),] # delete strange data

# Step 5: Division of crimes to totally three types #
test<-cr3
test$all<-1
size4<-nrow(test)
#####
for(i in 1:size4){
  if(test[i,2]=="ABORTION"){
    test$p[i]<-0 # property = p
    test$v[i]<-0 # violent = v
  }else if(test[i,2]=="ADMINISTRATIVE CODE"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="ADMINISTRATIVE CODES"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="ALCOHOLIC BEVERAGE CONTROL LAW"){ 
    test$p[i]<-1
    test$v[i]<-0
  }else if(test[i,2]=="ANTICIPATORY OFFENSES"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="ARSON"){
    test$p[i]<-1
    test$v[i]<-0
  }else if(test[i,2]=="ASSAULT 3 & RELATED OFFENSES"){
    test$p[i]<-0
    test$v[i]<-1
  }else if(test[i,2]=="BURGLAR'S TOOLS"){
    test$p[i]<-1
    test$v[i]<-0
  }else if(test[i,2]=="BURGLARY"){
    test$p[i]<-1
    test$v[i]<-0
  }else if(test[i,2]=="CHILD ABANDONMENT/NON SUPPORT"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="CHILD ABANDONMENT/NON SUPPORT 1"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="CRIMINAL MISCHIEF & RELATED OF"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="CRIMINAL MISCHIEF & RELATED OFFENSES"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="CRIMINAL TRESPASS"){
    test$p[i]<-0
    test$v[i]<-1
  }else if(test[i,2]=="DANGEROUS DRUGS"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="DANGEROUS WEAPONS"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="DISORDERLY CONDUCT"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="DISRUPTION OF A RELIGIOUS SERVICE"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="ENDAN WELFARE INCOMP"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="ESCAPE 3"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="FELONY ASSAULT"){
    test$p[i]<-0
    test$v[i]<-1
  }else if(test[i,2]=="FORCIBLE TOUCHING"){
    test$p[i]<-0
    test$v[i]<-1
  }else if(test[i,2]=="FORGERY"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="FRAUDS"){
    test$p[i]<-1
    test$v[i]<-0
  }else if(test[i,2]=="FRAUDULENT ACCOSTING"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="GAMBLING"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="GRAND LARCENY"){
    test$p[i]<-1
    test$v[i]<-0
  }else if(test[i,2]=="GRAND LARCENY OF MOTOR VEHICLE"){
    test$p[i]<-1
    test$v[i]<-0
  }else if(test[i,2]=="HARRASSMENT 2"){
    test$p[i]<-0
    test$v[i]<-1
  }else if(test[i,2]=="HOMICIDE-NEGLIGENT,UNCLASSIFIED"){
    test$p[i]<-0
    test$v[i]<-1
  }else if(test[i,2]=="HOMICIDE-NEGLIGENT-VEHICLE"){
    test$p[i]<-0
    test$v[i]<-1
  }else if(test[i,2]=="INTOXICATED & IMPAIRED DRIVING"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="INTOXICATED/IMPAIRED DRIVING"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="JOSTLING"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="KIDNAPPING & RELATED OFFENSES"){
    test$p[i]<-0
    test$v[i]<-1
  }else if(test[i,2]=="LOITERING"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="FRAUDS"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="LOITERING FOR DRUG PURPOSES"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="LOITERING/GAMBLING (CARDS, DICE, ETC)"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="MISCELLANEOUS PENAL LAW"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="MOVING INFRACTIONS"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="MURDER & NON-NEGL. MANSLAUGHTER"){
    test$p[i]<-0
    test$v[i]<-1
  }else if(test[i,2]=="NEW YORK CITY HEALTH CODE"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="OFF. AGNST PUB ORD SENSBLTY &"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="OFF. AGNST PUB ORD SENSBLTY & RGHTS TO PRIV"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="OFFENSES AGAINST PUBLIC ADMINISTRATION"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="OFFENSES AGAINST PUBLIC SAFETY"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="OFFENSES AGAINST THE PERSON"){
    test$p[i]<-0
    test$v[i]<-1
  }else if(test[i,2]=="OFFENSES INVOLVING FRAUD"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="OFFENSES RELATED TO CHILDREN"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="OTHER OFFENSES RELATED TO THEFT"){
    test$p[i]<-1
    test$v[i]<-0
  }else if(test[i,2]=="OTHER STATE LAWS"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="OTHER STATE LAWS (NON PENAL LA"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="OTHER STATE LAWS (NON PENAL LAW)"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="OTHER TRAFFIC INFRACTION"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="PARKING OFFENSES"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="PETIT LARCENY"){
    test$p[i]<-1
    test$v[i]<-0
  }else if(test[i,2]=="POSSESSION OF STOLEN PROPERTY"){
    test$p[i]<-1
    test$v[i]<-0
  }else if(test[i,2]=="POSSESSION OF STOLEN PROPERTY 5"){
    test$p[i]<-1
    test$v[i]<-0
  }else if(test[i,2]=="PROSTITUTION & RELATED OFFENSES"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="RAPE"){
    test$p[i]<-0
    test$v[i]<-1
  }else if(test[i,2]=="ROBBERY"){
    test$p[i]<-0
    test$v[i]<-1
  }else if(test[i,2]=="SEX CRIMES"){
    test$p[i]<-0
    test$v[i]<-1
  }else if(test[i,2]=="THEFT-FRAUD"){
    test$p[i]<-1
    test$v[i]<-0
  }else if(test[i,2]=="UNAUTHORIZED USE OF A VEHICLE 3 (UUV)"){
    test$p[i]<-1
    test$v[i]<-0
  }else if(test[i,2]=="UNLAWFUL POSS. WEAP. ON SCHOOL GROUNDS"){
    test$p[i]<-0
    test$v[i]<-0
  }else if(test[i,2]=="VEHICLE AND TRAFFIC LAWS"){
    test$p[i]<-0
    test$v[i]<-0
  }
}
#####
cr4<-test

# Step 6: Extract information about temporal resolution
t6<-cr4
size6<-nrow(t6)
for(i in 1:size6){
  t6$Week[i]<- week(t6$ARREST_DATE[i]) # create new attribute which shows the week
}

# Step 7: Setting the appropriate Projected Coordinate Reference System (PCRS)
forcrimes <- t6
crimes16 <- forcrimes %>% st_as_sf(coords=c("X_COORD_CD","Y_COORD_CD"), crs=102718, remove=FALSE) # to get crime incidents as spatial features

# Step 8: Spatial Join & Step 9: Summarizing the amount of crime incidents per study zones and per crime type
Result16z<-data.frame()
forfinal16z<-data.frame()
cr6<-t6[,c(2:10)] # keep only what is required
crimes16 <- cr6 %>% st_as_sf(coords=c("X_COORD_CD","Y_COORD_CD"), remove=FALSE) 

for (i in 1:53) {
  Cr16W53z<-crimes16[(crimes16$Week==toString(i)),] 
  # spatial join
  SJ16W53z<-st_join(zp1, Cr16W53z)
  # group based on the geometry of points for crimes15w1
  SUM16W53z <- SJ16W53z %>%
    group_by(ZIPCODE) %>% # group by the unique code of zipcodes
    summarize(sumall = sum(all), sump = sum(p), sumv = sum(v))  # all= all crimes, p=property and v=violent
  sizesum<-nrow(SUM16W53z)
  for (j in 1:sizesum){
    SUM16W53z$wk[j]<-i
  }
  if (i==1){
    Result16z<-SUM16W53z
  }
  else{
    Result16z<-rbind(Result16z,SUM16W53z)
  }
}

# Step 10: Replace the N.A. (non-available) values with zero number of incidents
Result16_2z<-Result16z
sizesum<-nrow(Result16_2z)
for (i in 1:sizesum){
  if(is.na(Result16_2z[i,2])){
    Result16_2z$sumall[i]<-0
    Result16_2z$sump[i]<-0
    Result16_2z$sumv[i]<-0
  }
}

# Step 11: Replacing of polygons with points regarding the geometry of study zones
forfinal16z <- st_centroid(Result16_2z) # calculate the centroid & keep the other attributes
coordsz <- st_centroid(Result16_2z) %>% st_coordinates() %>% as.data.frame() # the X,Y coordinates
final16z <- bind_cols(forfinal16z, coordsz) # group required attributes
st_write(final16z, "final16z.shp") # export data as shape file

# The file "final16z" is ready to be used as input for the KDE method
# The STARMA method requires the followings:

# Step 12: Make separate files for each type crime
#final16z<-ZIPCODE, sumall, sumv, sump, geometry(POINTS), wk, X, Y: 13144 rows 
#Result16_2z<-ZIPCODE, sumall, sumv, sump, geometry (POLYGONS) wk: 13144 rows 

Zip_allg<-Result16_2z[,c(1,2,5,6)]
Zip_pg<-Result16_2z[,c(1,3,5,6)]
Zip_vg<-Result16_2z[,c(1,4,5,6)]

Zip_all<-as.data.frame(Zip_allg)
Zip_all<-Zip_all[,c(1,2,4)] # without geometry
Zip_p<-as.data.frame(Zip_pg)
Zip_p<-Zip_p[,c(1,2,4)]
Zip_v<-as.data.frame(Zip_vg)
Zip_v<-Zip_v[,c(1,2,4)]

# Step 13: Transposition of data in order to have "weeks" as rows and "zipcodes" as columns
#transpose for type all
nworking<-nrow(Zip_all) # calculation of number of rows of existing dataset
w<-1 # start from first week
my.names<-c()
zipall53<-data.frame()
y<-1 

for (i in 1:nworking) {
  if (w<54){
    if (Zip_all[i,3]==1){ #4 corresponds to week column information
      my.names[i]<- Zip_all[i,1] #1 corresponds to zip code column information
      zipall53[1,i]<- Zip_all[i,2] #2 corresponds to amount of crimes for the examining type
    }
    else {
      zipall53[w,y]<- Zip_all[i,2]
      y<-y+1
    }
    if (i==248){
      colnames(zipall53) <- my.names
    }
    if (i%%248==0){
      w<-w+1
      y<-1
    }
  }
  else{
    break
  }
}
working_for_Zip_all<- zipall53


#transpose for type property
nworking<-nrow(Zip_p) #calculation of number of rows of existing dataset
w<-1 # start from first week
my.names<-c()
zipp53<-data.frame()
y<-1 

for (i in 1:nworking) {
  if (w<54){
    if (Zip_p[i,3]==1){ #4 corresponds to week column information
      my.names[i]<- Zip_p[i,1] #1 corresponds to zip code column information
      zipp53[1,i]<- Zip_p[i,2] #2 corresponds to amount of crimes for the examining type
    }
    else {
      zipp53[w,y]<- Zip_p[i,2]
      y<-y+1
    }
    if (i==248){
      colnames(zipp53) <- my.names
    }
    if (i%%248==0){
      w<-w+1
      y<-1
    }
  }
  else{
    break
  }
}
working_for_Zip_p<- zipp53


#transpose for type violent
nworking<-nrow(Zip_v) #calculation of number of rows of existing dataset
w<-1 # start from first week
my.names<-c()
zipv53<-data.frame()
y<-1 

for (i in 1:nworking) {
  if (w<54){
    if (Zip_v[i,3]==1){ #4 corresponds to week column information
      my.names[i]<- Zip_v[i,1] #1 corresponds to zip code column information
      zipv53[1,i]<- Zip_v[i,2] #2 corresponds to amount of crimes for the examining type
    }
    else {
      zipv53[w,y]<- Zip_v[i,2]
      y<-y+1
    }
    if (i==248){
      colnames(zipv53) <- my.names
    }
    if (i%%248==0){
      w<-w+1
      y<-1
    }
  }
  else{
    break
  }
}
working_for_Zip_v<- zipv53

# Step 14: Extract information for study zones' geometry 
#BZ_def_geo <- zp1[,c(1,3)] only zipcodes with geometry as polygons
XY_Bz<-st_centroid(BZ_def_geo) %>% st_coordinates() %>% as.data.frame() 
XY_Bz_MATRIX<-as.matrix(XY_Bz) 
my_sites_Bz<-XY_Bz_MATRIX
