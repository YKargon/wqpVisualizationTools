library(sf)
library(rmapshaper)

#' Simplify HUC Shapes from WBD --------------------------------------------
#' 
#' Simplifies HUC boundaries from WBD dataset using ms_simplify, saves as .gpkg
#' Uses ms_simplify's 'sys=T' function, requires system version of map shaper to be installed
#' Saved gpkg doesn't seem to store CRS/ESPG number
#'
#' @param wbd_path String, filepath for st_read
#' @param level Numeric, HUC level for simplification
#' 
simplifyHUCBoundary <- function(wbd_path, level) {
    # varName <- paste("huc", level, "Bounds", sep = "")
    layerName <- paste("WBDHU", level, sep = "")
    bounds <- st_read(wbd_path, layerName, quiet=TRUE)

    # Uses rmapshaper's ms_simplify
    # Defaults seem to be pretty good for our applications (interactive leaflet map)
    simplifiedBounds <- ms_simplify(bounds, sys=T)
    
    # st_write can't write .gdb files
    st_write(simplifiedBounds, paste(layerName, ".gpkg", sep = ""), delete_layer = TRUE)
}

setwd("~/Documents/School/Duke/Summer 2019/Data+/")

wbd_path <- "Datasets/WBD_National_GDB/WBD_National_GDB.gdb/"

for (i in seq(2, 12, 2)) {
  simplifyHUCBoundary(wbd_path, i)
}