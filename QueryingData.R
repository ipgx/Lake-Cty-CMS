library(tmaptools)
library(leaflet)
library(tidygeocoder)
library(tibble)

combine_columns <- function(csv_file_path) {
  # Read the CSV file
  df <- read.csv(csv_file_path)
  
  # Combine first and second columns with " & "
  df$Road_From <- paste(df[, 1], "&", df[, 2], ", Lake County, FL")
  
  # Combine first and third columns with " & "
  df$Road_To <- paste(df[, 1], "&", df[, 3], ", Lake County, FL")
  
  # Return the modified dataframe
  return(df)
}

# Example usage:
# result_df <- combine_columns("Segments.csv")
# View(result_df)

# Run the function with the Segments.csv file
result_df <- combine_columns("Segments.csv")

# Display the first few rows
head(result_df)
result_df <- result_df %>%
   mutate(address = Road_To)

#locations_txt <- data.frame(location = c("Alvin, TX, USA", "Athens, GA, USA"))
# nominatim_loc_geo <- geocode_OSM(result_df$Road_From[1], as.data.frame = TRUE)
# print(nominatim_loc_geo)



x_to <- result_df %>%
  select(1,6) %>% 
  geocode(address, method = 'arcgis') # , lat = latitude , long = longitude


leaflet() %>%
  addTiles() %>%
    addCircleMarkers(lat = x_to$lat,
                     lng = x_to$long,
                     popup = x_to$address)

leaflet() %>%
  addTiles() %>%
  addCircleMarkers(lat = x$lat,
                   lng = x$long,
                   popup = x$address)

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