# Function to combine columns with "&" separator
combine_columns <- function(csv_file_path) {
  # Read the CSV file
  df <- read.csv(csv_file_path)
  
  # Combine first and second columns with " & "
  df$Road_From <- paste(df[, 1], "&", df[, 2])
  
  # Combine first and third columns with " & "
  df$Road_To <- paste(df[, 1], "&", df[, 3])
  
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
