##--------------------------------------------------------------
##
## high.severity.class.metrics.R
##
## Purpose: Output landscape pattern metrics for classified images
##
## Author: S. Haire, @HaireLab 
## 
##
## 3 july 2020
## 
##--------------------------------------------------------------

### Notes:
##Before running this script, download the dnbr images < https://doi.org/10.5066/P9BB5TIO >

##Then run fire.poly.pcvalues.R (output fire.poly.pcvalues.shp)

## Algorithm 

##1. loop through dnbr images
##2. Read in first dnbr image and aggregate (rescale) by max value
##3. Classify the dnbr image using (21) alternative thresholds 
##4. Output a table with pattern metrics for the image, and polygon info for the fire. This script outputs three metrics, but only PLAND (% high severity) was used in the manuscript analysis.


## set paths to input and output datasets
imgpath<-'./data/dnbr.images/' # dnbr images 
perimpath<-'./data/sp' # fire perimeter polys
outpath<-'./data/tabular/' # save the data table here

library(raster)
library(rgdal)
library(landscapemetrics)

##data 
## read in the spatial polygons
perims<-readOGR(perimpath, "fire.polys.pcvalues")
## list the dnbr images and their rootname
lf<-list.files(imgpath)
lf.root<-tools::file_path_sans_ext(lf)

### Define the classes

cutpts<-seq(450, 650, by=10) # vector for choosing cut pts, length=21

### Output the pattern metrics
## Loop through the fires, matching the dnbr image name with spatial polygons Fire_ID. For each version of the classified dnbr image (defined by alternative threshold values),output three pattern metrics. 

for (i in 1:length(lf)) {
  p1<-perims[perims$Fire_ID==lf.root[i],]
  r<-raster(paste(imgpath, lf[i], sep=""))
  a<-aggregate(r, fact=33, fun=max)
  r2<-mask(a, p1)
  p1.df<-data.frame(p1)
  for (k in 1:length(cutpts)) {
    cut1<-cutpts[k] # define threshold k
    #apply threshold definition to image i 
    rc<-reclassify(r2, c(-Inf,cut1,0, cut1, Inf, 1))
    # composition
    pland=sum(rc[]==1, na.rm=TRUE)/length(rc)   
    # clumpy
    clumpy<-data.frame(lsm_c_clumpy(rc))
    ## cv of dist to nn
    nndist.cv<-data.frame(lsm_c_enn_cv(rc))
    # output pattern metrics in a table w poly info
    res1<-cbind(cut1, p1.df, pland, clumpy[2,6], nndist.cv[2,6])
    write.table(res1, paste(outpath,"class.metrics.high.txt", sep=""), append=TRUE, row.names=FALSE, col.names=FALSE)
  } ## next threshold
} ## next image

##Read the text file back in, assign names and write to .csv.
Print the dimensions and summary of the table.

res<-read.table(paste(outpath,"class.metrics.high.txt", sep=""))
cat(dim(res)[1], "rows", dim(res)[2], "columns", "\n") # 335 fires
names(res)<-c("threshold.value", names(p1.df), "pland", "clumpy", "nndist.cv")
summary(res) # some nas for clumpy and distance metrics
write.csv(res, paste(outpath, "class.metrics.high.csv",sep=""))     

