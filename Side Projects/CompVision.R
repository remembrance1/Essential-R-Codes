setwd("C:/Users/zm679xs/Desktop/R/Side Projects")

# Normal Libraries
library(tidyverse)

#devtools::install_github("flovv/RoogleVision")
library(RoogleVision)
library(jsonlite) # to import credentials

# For image processing
#source("http://bioconductor.org/biocLite.R")
#biocLite("EBImage")
library(EBImage)

# For Latitude Longitude Map
library(leaflet)

# Credentials file I downloaded from the cloud console
creds = fromJSON('cred.json')

options("googleAuthR.client_id" = creds$installed$client_id)
options("googleAuthR.client_secret" = creds$installed$client_secret)
options("googleAuthR.scopes.selected" = c("https://www.googleapis.com/auth/cloud-platform"))
googleAuthR::gar_auth()

# Instructions

# The function getGoogleVisionResponse takes three arguments:
#   
# imagePath
# feature
# numResults
# 
# Numbers 1 and 3 are self-explanatory, "feature" has 5 options:
#   
# LABEL_DETECTION
# LANDMARK_DETECTION
# FACE_DETECTION
# LOGO_DETECTION
# TEXT_DETECTION

# Testing Image

#Label Detection
#This is used to help determine content within the photo. It can basically add a level of metadata around the image.
sea <- getGoogleVisionResponse('Paracas_National_Reserve,_Ica,_Peru-3April2011.jpg',
                                             feature = 'LANDMARK_DETECTION')
head(sea)

###################################################################################################################
#Landmark Detection
eiffel <- getGoogleVisionResponse('eiffel.jpg', feature = 'LANDMARK_DETECTION')
head(eiffel)

eiffelimg <- readImage('eiffel.jpg')
plot(eiffelimg)
xs = eiffel$boundingPoly$vertices[[1]][1][[1]]
ys = eiffel$boundingPoly$vertices[[1]][2][[1]]
polygon(x=xs,y=ys,border='red',lwd=4) #shows where google cloud vision api looked at to identify the image

#plotting location
latt = eiffel$locations[[1]][[1]][[1]]
lon = eiffel$locations[[1]][[1]][[2]]
m = leaflet() %>%
  addTiles() %>%
  setView(lng = lon, lat = latt, zoom = 10) %>%
  addMarkers(lng = lon, lat = latt, popup = eiffel$description)
m
