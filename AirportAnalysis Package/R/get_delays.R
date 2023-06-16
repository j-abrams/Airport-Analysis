


#' get_delays
#'
#' This function filters CSV files in a directory based on a threshold, reads the selected files,
#' combines them into a single data frame, and calculates the average delay time and proportion
#' of flights that are delayed.
#'
#' @param directory The directory path where the CSV files are located.
#' @param threshold The threshold for filtering the files based on numeric values in their names.
#'
#' @return A list containing the average delay time and proportion of delayed flights.
#'
#' @examples
#' filter_csv_files("path/to/csv/files", 5000)
#'
#' @importFrom dplyr bind_rows distinct %>%
#' @importFrom readr read_csv
#'
#' @export


get_delays <- function(directory, threshold) {
  
  # Function body
  # Get a list of all CSV files in the directory
  csv_files <- list.files(directory, pattern = "*.csv", full.names = TRUE)
  
  # Filter the files based on the last 8 digits
  filtered_files <- csv_files[grepl("_[0-9]{4}_[0-9]{4}\\.csv$", csv_files)]
  
  # Extract the numeric values from the file names
  numeric_values <- sub(".*_([0-9]{4})_([0-9]{4})\\.csv$", "\\1\\2", filtered_files)
  
  # Convert the numeric values to integers
  numeric_values <- as.integer(numeric_values)
  
  # Filter the files based on the numeric values
  selected_files <- filtered_files[numeric_values >= threshold]
  
  # Read the selected CSV files
  data <- lapply(selected_files, read_csv)
  
  # Combine the individual data frames into a single data frame
  combined_data <- bind_rows(data) %>%
    distinct(arr_iata, dep_time, .keep_all = TRUE)
  
  
  # Calculate average delay time
  average_delay <- round(mean(combined_data$delayed, na.rm = TRUE), 0)
  
  # Calculate proportion of flights which are delayed
  proportion_delayed <- 1 - sum(is.na(combined_data$delayed)) / nrow(combined_data)
  proportion_delayed <- as.double(proportion_delayed)
  
  return(list(average_delay, proportion_delayed, combined_data))
  
}


