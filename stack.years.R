##----------------------------------------------------------------
## 
## stack.years.R
## 
## Purpose: Output data to use in calculating mean fire return interval 
## for 1985-2017 fires and save for future use in calculating mean fire return interval.
##
##---------------------------------------------------------------------
### Notes:
 
## Simple algorithm
##1. create a stack of raster layers 1 per fire year with value = year and bckgn = 0
##2. save the data for use in random.sample.Rmd
 
##Input data:
##fire polygon shp: <https://doi.org/10.5066/P9BB5TIO>
##Number of fires (raster) is available in project data folder.
## Purpose: append information to fire polygons
## for analysis of high severity metrics
##
## Author: S. Haire, @HaireLab 
## 
##
## Date: 3 july 2020
##
##---------------------------------------------------------------------
##
library(raster)
library(rgdal)
library(dplyr)

### Read in the fire poly data and the times burned raster (for use as template) 
sppath<-"./data/sp"
## input data
## read in perims (fire polys)
perims<-readOGR(sppath, "Sky_Island_Fire_Polys_1985_2017") 
## times burned raster for template
tmsb<-raster("./data/more.rasters/N.fires100m.tif")

### Rasterize the fire polys, one year at a time. Create a stack of the raster layers and save.

## initialize count variable 
u=2017:1985 
## initialize stack for the years layers
s<-stack()
for (i in 1:length(u)) {
  y1<-perims[perims$Year==u[i],]
  y1.ras<-rasterize(y1, tmsb, field=1) # numeric value = 1
  y1.ras[is.na(y1.ras)]<-0
  y1.ras[y1.ras==1]<-u[i]
  s<-addLayer(s, y1.ras)
}
## save the years stack
writeRaster(s, "./data/more.rasters/years", bandorder="BIL", overwrite=TRUE)


