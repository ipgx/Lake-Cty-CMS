library(tmaptools)
library(leaflet)
library(tidygeocoder)
library(tibble)
library(tidycensus)
library(sf)

setwd("C:\\Users\\paragg\\Documents\\CMS-GIS\\Lake-Cty-CMS")


fips_Codes <- fips_codes
fl_county <- get_acs(geography = "county",
                       state = "FL", 
                       geometry = T, 
                       table = "B02001",
                      output = "wide")

lake_county <- fl_county[fl_county$GEOID == "12069", ]


combine_columns <- function(csv_file_path) {
  # Read the CSV file
  df <- read.csv(csv_file_path)
  print(head(df))
  
  # Combine first and second columns with " & "
  df$Road_From <- paste(df[, 2], "&", df[, 3], ", Lake County, FL")
  
  # Combine first and third columns with " & "
  df$Road_To <- paste(df[, 2], "&", df[, 4], ", Lake County, FL")
  
  # Return the modified dataframe
  return(df)
}

# Example usage:
# result_df <- combine_columns("Segments.csv")
# View(result_df)

# Run the function with the Segments.csv file
result_df <- combine_columns("Segments.csv")
head(result_df)
# Display the first few rows



#locations_txt <- data.frame(location = c("Alvin, TX, USA", "Athens, GA, USA"))
# nominatim_loc_geo <- geocode_OSM(result_df$Road_From[1], as.data.frame = TRUE)
# print(nominatim_loc_geo)

result_df <- result_df %>%
  mutate(address = Road_From)

x_from <- result_df %>%
  select(1,7) %>% 
  geocode(address, method = 'arcgis') # , lat = latitude , long = longitude

result_df <- result_df %>%
  mutate(address_2 = Road_To)

x_to <- result_df %>%
  select(1,8) %>% 
  geocode(address_2, method = 'arcgis') 


leaflet() %>%
  addTiles() %>%
    addCircleMarkers(lat = x_from$lat,
                     lng = x_from$long,
                     popup = x_from$address,
                     color = "red",
                     group = "FROM") %>%
    addCircleMarkers(lat = x_to$lat,
                     lng = x_to$long,
                     color = "green",
                      popup = x_to$address_2,
                     group = "TO") %>%
  addPolygons(data = st_transform(lake_county, 4326),
              color = "black", opacity = 0.5, group = "COUNTY") %>%
  addLayersControl(overlayGroups = c("FROM", "TO", "COUNTY"))



# library(mapsapi)
# Define the address and your API key
# address <- "1600 Amphitheatre Parkway, Mountain View, CA"
# api_key <- "<YOUR_API_KEY>"
# 
# # Perform the geocoding request
# geocode_response <- mp_geocode(address, key = api_key)
# 
# # Process the response to get coordinates as a data frame
# coordinates <- mp_get_points(geocode_response)
# 
# # View the results
# print(coordinates)