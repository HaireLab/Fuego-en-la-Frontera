##----------------------------------------------------------------
## 
## fire.polygon.pcvalues.R
## 
## Purpose: append princiipal component values (mean within fire perimeter) 
## to fire polygon shp to use in analysis of high severity metrics
##
## Author: S. Haire, @HaireLab 
## 
##
## Date: 3 july 2020
##
##--------------------------------------------------------------
##
## Notes:
## Before running this script, download the fire perimeters 
## < https://doi.org/10.5066/P9BB5TIO >
##
## PC1 and PC2 rasters are available in the respository data folder
##
##---------------------------------------------------------------

library(raster)
library(rgdal)
library(landscapemetrics)
library(plyr)
library(dplyr)
library(geosphere)

##  Read in the data and project the fire perimeter polygons to match the principal component layers

## paths to input data
perimpath<-'./data/sp'# fire perimeters...put the shp with new attributes here too
pcpath<-'./data/PCA/' ## PCA rasters

## data 
## pc's have bioclim data projection
bioclim.prj<-"+proj=lcc +lat_1=49 +lat_2=77 +lat_0=0 +lon_0=-95 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs" # from metadata lambert conformal conic
## read in pc's and assign prj
pc1<-raster(paste(pcpath, "PC1b.rot.tif", sep="")); crs(pc1)<-bioclim.prj
pc2<-raster(paste(pcpath, "PC2b.rot.tif", sep="")); crs(pc2)<-bioclim.prj
## read in perimeters/sp polys and project the perimeters to match the pc's
perims<-readOGR(perimpath, "Sky_Island_Fire_Polys_1985_2017")
perims.lcc<-spTransform(perims, bioclim.prj)

## Extract pc 1 & pc2 values and output the mean w/in polygon (fire perimeter). Save appended shp.
## stack the pc's and extract values within the polygons
s<-stack(pc1,pc2)
pc.ex<-extract(s, perims.lcc, method="bilinear",df=TRUE)
## calulate the mean values within the fire perimeters
mean.pc<-ddply(pc.ex,~ID, summarise, mean.pc1 = mean(PC1b.rot), mean.pc2=mean(PC2b.rot))

## add pc mean values to the spatial polygons
perims$pc1<-mean.pc[,2]; perims$pc2<-mean.pc[,3]
perims<-perims[,c(1:5,15,16)] ## just save the year, name & id, country, sky island and pc values

## save the perim shp 
writeOGR(perims, "./data/sp", "fire.polys.pcvalues", driver="ESRI Shapefile",  overwrite=TRUE)


