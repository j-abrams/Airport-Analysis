


#' Combine CSV Files
#'
#' This function reads all CSV files from a specified folder and combines their data into a single data frame.
#'
#' @param folder_path The path to the folder containing the CSV files.
#'
#' @return A data frame containing the combined data from all CSV files.
#' @export
#'
#' @importFrom dplyr distinct
#' @importFrom dplyr select
#' @importFrom dplyr filter
#' @importFrom dplyr bind_rows
#'
#' @examples
#' # Combine CSV files from a folder
#' combined_data <- combine_csv_files(folder_path = "path/to/csv/folder")



# Read all files in from specified location
combine_csv_files <- function(folder_path, type = "departures") {
  # Get the list of CSV files in the specified folder
  files <- list.files(folder_path, pattern = "*.csv", full.names = TRUE)
  
  # Create an empty data frame
  combined_data <- data.frame()
  
  # Iterate over each CSV file and combine the data
  
  if (type == "departures") {
  
    for (file in files) {
      data <- read.csv(file, stringsAsFactors = FALSE)
      combined_data <- bind_rows(combined_data, data) %>%
        distinct(arr_iata, dep_time, .keep_all = TRUE)
    }
    
  } else if (type == "delays") {
    
    # Remove duplicates and redundant data making use of the lag() function, and distinct()
    if (folder_path == "Data/departures" | folder_path == "Shiny/Data/departures") {
    
      for (file in files) {
        data <- read.csv(file, stringsAsFactors = FALSE)
        combined_data <- bind_rows(combined_data, data) %>%
          distinct(.keep_all = TRUE) %>%
          arrange(dep_time, airport_name) %>%
          filter(airport_name != lag(airport_name, default = "")) %>%
          filter(!is.na(airport_name))
      }
    } else if (folder_path == "Data/arrivals" | folder_path == "Shiny/Data/arrivals") {
      
      for (file in files) {
        data <- read.csv(file, stringsAsFactors = FALSE)
        combined_data <- bind_rows(combined_data, data) %>%
          distinct(.keep_all = TRUE) %>%
          arrange(dep_time, dep_iata) %>%
          filter(dep_iata != lag(dep_iata, default = "")) %>%
          filter(!is.na(dep_iata))
      }
    }
      
      
  }
    
    
  
  # Reset the row names
  rownames(combined_data) <- NULL
  
  # Return the combined data frame
  return(combined_data)
}



