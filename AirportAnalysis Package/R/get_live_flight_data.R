

#' Get live flight data for departures or arrivals
#'
#' This function retrieves live flight data for departures or arrivals from the Airlabs API
#' based on the specified flight type (departures or arrivals) and airport.
#'
#' @param flight_type A character string specifying the type of flight data to retrieve.
#'                    Must be either "departures" or "arrivals".
#' @param airport A character string specifying the airport code.
#'                The flight data will be filtered based on this airport.
#'
#' @return A data frame containing the flight data.
#'
#' @examples
#' get_flight_data("departures", "LAX")
#' get_flight_data("arrivals", "LAX")
#'
#' @export





# Current Performance Metrics
# Return listings for which departure / arrivals actuals are already know.

get_live_flight_data <- function(flight_type, airport) {
  
  # Conditional to accomodate for either departures or arrivals
  if (flight_type == "departures") {
    data <- get_airlabs_api_response(key = "schedules", 
                                     parameter_name = "dep_iata", 
                                     parameter_value = airport) %>%
      distinct(arr_iata, dep_time, .keep_all = TRUE) %>%
      select(airline_iata, 
             dep_iata, dep_terminal, dep_time, #dep_actual,
             dep_actual = dep_estimated, 
             arr_iata, #arr_time, arr_actual,
             delayed) %>%
      filter(!is.na(dep_actual))
    
    # Convert dep_actual and dep_time to POSIXct format
    data$dep_actual <- as.POSIXct(data$dep_actual)
    data$dep_time <- as.POSIXct(data$dep_time)
    
  } else if (flight_type == "arrivals") {
    data <- get_airlabs_api_response(key = "schedules", 
                                     parameter_name = "arr_iata", 
                                     parameter_value = airport) %>%
      distinct(arr_iata, dep_time, .keep_all = TRUE) %>%
      select(airline_iata, 
             dep_iata, dep_time, dep_time_utc, dep_actual, 
             arr_iata, arr_terminal, arr_time, arr_time_utc, #arr_actual,
             arr_actual = arr_estimated,
             delayed) %>%
      filter(!is.na(arr_actual))
    
    data$arr_actual <- as.POSIXct(data$arr_actual)
    data$arr_time <- as.POSIXct(data$arr_time)
      
  } else {
    stop("Invalid flight type. Please specify 'departures' or 'arrivals'.")
  }
  
  
  # Collect data then combine as before?
  # get_airlabs_api_response() is only able to return a small window of actual dep and arr times.

  
  data <- data %>%
    filter(!is.na(airline_iata)) %>%
    left_join(airports, by = c("arr_iata" = "iata_code")) %>%
    left_join(airlines, by = c("airline_iata" = "iata_code")) %>% 
    left_join(airports, by = c("dep_iata" = "iata_code")) %>%  
    # For categorising Domestic / International, use ifelse() for this process
    select(-c(country_code.x, country_code.y, name, icao_code)) %>%
    dplyr::rename("airport_name" = "name.x", "airline_name" = "name.y") %>%
    select(airline_name, airport_name, everything())
  
  
  
  
  # Add system time suffix to file name to remember timestamp
  current_time <- Sys.time()
  
  # Extract the hour and minute components from the current time
  current_minute <- format(current_time, "%d%m_%H%M")
  
  # Save the departures data
  
  # shinyapps.io
  #data_full <- bind_rows(combined_data, data) %>%
  #  distinct(.keep_all = TRUE)
  
  
  # legacy commands

  # SHINY
  
  #write.csv(data, paste0("Data/", flight_type, "/YYZ_", flight_type, "_", current_minute, ".csv"), row.names = FALSE)
  #data_full <- combine_csv_files(paste0("Data/", flight_type), type = "delays")

  # LOCAL ENV
  
  write.csv(data, paste0("Shiny/Data/", flight_type, "/YYZ_", flight_type, "_", current_minute, ".csv"), row.names = FALSE)
  data_full <- combine_csv_files(paste0("Shiny/Data/", flight_type), type = "delays")

  print(nrow(data_full))
  
  return(data_full)
  #return(data)
}

