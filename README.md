# Fuego-en-la-Frontera

### Data and code in this repository were used to conduct the analysis for the following manuscript: 

Villarreal, M.L., J.M. Iniguez, A.D. Flesch, J.S. Sanderlin, C. Cortés Montaño, C.R. Conrad, and S.L. Haire. 2020. Contemporary fire regimes provide a critical perspective on restoration needs in the Mexico-US borderlands. Air, Soil and Water Research--Special Collection on case studies of a grass roots binational restoration collaborative in the Madrean Archipelago Ecoregion (2014-2019). https://doi.org/10.1177/1178622120969191 

### Los datos y el código de este repositorio se utilizaron para realizar los análisis del siguiente manuscrito:
 
Villarreal, M.L., J.M. Iniguez, A.D. Flesch, J.S. Sanderlin, C. Cortés Montaño, C.R. Conrad, and S.L. Haire. 2020. Los regímenes contemporáneos de incendios brindan una perspectiva crítica sobre las necesidades de restauración en la frontera México-Estados Unidos. Investigación sobre aire, suelo y agua - Colección especial de estudios de caso de restauración binacional colaborativa y de base en la ecorregión del archipiélago Madrense (2014-2019). https://doi.org/10.1177/1178622120969191 

### R scripts and Report files, listed in order used to conduct the analysis. 
Datafiles available in the repository are listed in parentheses.  

### PCA

#### pca-bioclim.Rmd  
Purpose: Run PCA for the Sky Islands using bioclimatic variables.  

Input:  
bioclim variables <https://adaptwest.databasin.org/pages/adaptwest-climatena>  
Island polygons edited to correct polygon gap on Huachuca (Sky_Island_Complexes_edit.shp)  
Original island polygon shp available here: https://skyisland.maps.arcgis.com/home/item.html?id=6797fbaf9e524cae836925c5de6a186a  

Output:  
pca-bioclim.html  
PCA rasters (PC1b.rot.tif, PC2b.rot.tif, PC1.tif, PC2.tif)  

#### fire.pcvalues.R  
Purpose: Summarize the principal component values within fire perimeter polygons.  

Input:  
PC rasters (PC1b.rot.tif, PC2b.rot.tif)  
Fire polygons: (1985-2017) https://doi.org/10.5066/P9BB5TIO    

Output:  
Polygon shp appended with PC values (fire.polys.pcvalues.shp)  

### Figure 3: Vegetation and Ownership

#### vegetation.ownership.plots.Rmd 
Purpose: Plot the vegetative biome data and the ownership data across the PC1 and PC2 gradients.  

Input:  
Random sample data for vegetative biomes (veg.data.fig3.csv)  
Random sample data for ownership classes (own.data.fig3.csv)  

Output:  
vegetation.ownership.plots.html  

### Figure 4: High severity analysis  
#### high.severity.class.metrics.R   
Purpose: Rescale dNBR images and calculate % high severity based on multiple classification thresholds.  

Input:  
Fire polygons with pc attributes (fire.polys.pcvalues.shp)  
dNBR data:  
(1985-2011) https://doi.org/10.5066/P9P3NIXR
(2011-2017) https://doi.org/10.5066/P99S0I9W  

Output:  
Table of high severity class metrics and fire attributes (class.metrics.high.csv)  

#### high.severity.gams.Rmd  
Purpose: Run generalized additive models (% high severity ~ PC1) and plot the results.  
Input:  
Table of high severity class metrics and fire attributes (class.metrics.high.csv)  
Output:  
high.severity.gams.html  
 
### Figure 5: Times burned classes  
#### times.burned.plots.Rmd  
Purpose: Plot the times burned data across the PC1 and PC2 gradients.  
Input:  
Random sample data for times burned (timesb.data.fig5.csv)  
Output:  
times.burned.plots.html  

### Figure 6: Fire return interval classes  
#### stack.years.R  
Purpose: Create a stack of raster layers, one per fire year and save the data for use later.  
Input:  
fire perimeter polygons: (1985-2017) https://doi.org/10.5066/P9BB5TIO  
times burned raster (N.fires100m.tif)  
Output:  
Raster brick, fire years (years.tif)  

#### fire.return.interval.plots.Rmd  
Purpose: Calculate the mean fire return interval, classify and plot across the PC1 and PC2 gradients.  
Input:   
Random sample of fire years (mfri.data.fig6.txt)  
Output:  
fire.return.interval.plots.html  
