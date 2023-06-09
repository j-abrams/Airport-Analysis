


#' Extract departures
#'
#' This function performs data extraction, handling, and deep dive analysis on scheduled departures data
#' for a specific airport.
#'
#' @param parameter_value The airport code for which to extract and analyze data.
#'
#' @return A data frame containing the deep dive analysis results for the specified airport.
#' @export
#'
#' @importFrom dplyr select
#' @importFrom dplyr filter
#' @importFrom dplyr left_join
#' @importFrom dplyr mutate
#' @importFrom dplyr group_by
#' @importFrom dplyr ungroup
#' @importFrom dplyr distinct
#'
#' @examples
#' # Extract and analyze data for LAX airport
#' data <- extract_departures(parameter_value = "LAX")
#' # Extract and analyze data for LHR airport
#' data <- extract_departures(parameter_value = "LHR")


#### Master function
# Nested function contains previous steps compiled into one to return one output: departures_dd

# parameter_value" denotes airport code, for example "LAX"
# parameter_value <- "YYZ"
extract_departures <- function(parameter_value) {
  
  # Data Extraction
  scheduled_departures <- get_airlabs_api_response(key = "schedules", 
                                                   parameter_name = "dep_iata", 
                                                   parameter_value = parameter_value) %>%
    distinct(arr_iata, dep_time, .keep_all = TRUE)
  
  # Data Handling
  
  departures <- scheduled_departures %>%
    select(all_of(fields_departures)) %>%
    mutate(flight_number = as.numeric(flight_number)) %>%  # Quick fix for flight_number field
    filter(!is.na(flight_number))
    
  # Filter only for Thomas Bradley terminal in the event where we are observing LAX
  if (parameter_value == "LAX") {
    departures <- departures %>%
      filter(dep_terminal == "TBIT")
  }
  
  
  # Save results as we go...
  
  # Add system time suffix to file name to remember timestamp
  current_time <- Sys.time()
  
  # Extract the hour and minute components from the current time
  current_minute <- format(current_time, "%d%m_%H%M")
  
  # Save the departures data
  write.csv(departures, paste0("Raw_Data/", parameter_value, "/", parameter_value,
                               "_departures_", current_minute, ".csv"), row.names = FALSE)
  
  
  departures_full <- combine_csv_files(paste0("Raw_Data/", parameter_value))
  print(nrow(departures_full ))
  
  # Departures Deep Dive
  # top_airlines and top_airports fields determine the most popular airlines and airports respectively
  # Categorize Domestic and International flights.
  departures_dd <- departures_full %>%
    select(arr_iata, dep_iata, airline_iata, dep_time) %>%
    group_by(arr_iata) %>%
    mutate(top_airports = n()) %>%
    ungroup() %>%
    group_by(airline_iata) %>%
    mutate(top_airlines = n()) %>%
    ungroup() %>%
    filter(!is.na(airline_iata)) %>%
    left_join(airports, by = c("arr_iata" = "iata_code")) %>%
    left_join(airlines, by = c("airline_iata" = "iata_code")) %>% 
    left_join(airports, by = c("dep_iata" = "iata_code")) %>%  
    # For categorising Domestic / International, use ifelse() for this process
    mutate(destination =  ifelse(country_code.x == country_code.y, 
                                 "Domestic", "International")) %>%
    
    select(-c(country_code.x, country_code.y, name, arr_iata, airline_iata, icao_code)) %>%
    dplyr::rename("airport_name" = "name.x", "airline_name" = "name.y") %>%
    select(airline_name, airport_name, everything())
  # Note: SQ matches to Singapore airlines and Singapore Cargo... 
  # Hence warning about many-to-many relationship
  
  
  return(departures_dd)
}

# Usage
#data <- extract_and_analyze_data(parameter_value = "LAX")
#data <- extract_and_analyze_data(parameter_value = "LHR")

