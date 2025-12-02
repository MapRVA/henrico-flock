#! /usr/bin/Rscript

library(pdftools)
library(dplyr)
library(tidyr)
library(tidygeocoder)
library(sf)

# Import PDF
pdf_text("/home/obrien/Downloads/County Flock Locations - 11-25-2025.pdf") |>

# convert to data.frame
read.delim(text = _, col.names = "col") |>

# split columns
separate_wider_regex(col, patterns = c(id = ".*[\\d ]\\d ", location = ".*\\s{2,}", station = ".* [CSW].*")) |>

# clean
mutate_all(trimws) |>
mutate(
    address = gsub(" [EWNS]B", '', location),
    address = paste0(address, ", Henrico, VA")
) |> 

# geocode
geocode(address = address, method = 'arcgis') |>

# convert to WKT
st_as_sf(coords = c("long", "lat"), crs = 4326) |>

# write to GeoJSON
st_write("henrico_flock_2025.geojson")
