


# shiny_functions

## Sole purpose of this script - enable deployment with sinyapps.io web hosting services
# TODO: Investigate. Why are these functions different from the ones created in my pckage
# I am not sure to be honest. I guess I need them uploaded to shinyapps.io.
# That is the key driver

# core api function
get_airlabs_api_response <- function(key, parameter_name = "parameter1", parameter_value = "value1",
                                     parameter_name2 = "parameter2", parameter_value2 = "value2")  {
  
  url <- paste0("https://airlabs.co/api/v9/", key)
  
  params <- list(
    api_key = api_key
  )
  
  # Dynamically assign "parameter_name"
  # Syntax for this in R requires double brackets
  params[[parameter_name]] <- parameter_value
  params[[parameter_name2]] <- parameter_value2
  
  # Send the API request
  response <- httr::GET(url, query = params)
  
  # Extract the content of the response as JSON
  api_response <- jsonlite::fromJSON(content(response, "text"))
  
  # Convert the flight information to a data frame
  data <- as.data.frame(api_response$response)
  
  return(data)
}






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
    
    
    # Iterate over each CSV file and combine the data
    for (file in files) {
      data <- read.csv(file, stringsAsFactors = FALSE) %>%
        mutate(file = file)
      combined_data <- bind_rows(combined_data, data)
    }
    
    # Remove duplicates and redundant data based on "dep_time" and "airport_name"
    if (folder_path == "Data/departures" | folder_path == "Shiny/Data/departures") {
      combined_data <- combined_data %>%
        arrange(dep_time, airport_name, desc(file)) %>%
        distinct(dep_time, airport_name, .keep_all = TRUE)
    }
    
    # Remove duplicates and redundant data based on "dep_time" and "airport_name"
    if (folder_path == "Data/arrivals" | folder_path == "Shiny/Data/arrivals") {
      combined_data <- combined_data %>%
        arrange(arr_time, dep_iata, desc(file)) %>%
        distinct(arr_time, dep_iata, .keep_all = TRUE)
    }
    
    
    # Reset the row names
    rownames(combined_data) <- NULL
    
    
    # Remove duplicates and redundant data making use of the lag() function, and distinct()
    # if (folder_path == "Data/departures" | folder_path == "Shiny/Data/departures") {
    #   
    #   for (file in files) {
    #     data <- read.csv(file, stringsAsFactors = FALSE)
    #     combined_data <- bind_rows(combined_data, data) %>%
    #       distinct(.keep_all = TRUE) %>%
    #       arrange(dep_time, airport_name) %>%
    #       filter(airport_name != lag(airport_name, default = "")) %>%
    #       filter(!is.na(airport_name))
    #   }
    # } else 
    
    # if (folder_path == "Data/arrivals" | folder_path == "Shiny/Data/arrivals") {
    #   
    #   for (file in files) {
    #     data <- read.csv(file, stringsAsFactors = FALSE)
    #     combined_data <- bind_rows(combined_data, data) %>%
    #       distinct(.keep_all = TRUE) %>%
    #       arrange(dep_time, dep_iata) %>%
    #       filter(dep_iata != lag(dep_iata, default = "")) %>%
    #       filter(!is.na(dep_iata))
    #   }
    # }
    
    
  }
  
  
  
  # Reset the row names
  rownames(combined_data) <- NULL
  
  # Return the combined data frame
  return(combined_data)
  
}





# Current Performance Metrics
# Return listings for which departure / arrivals actuals are already know.

get_live_flight_data <- function(flight_type, airport) {
  
  # Set the time zone to Toronto
  Sys.setenv(TZ = "America/Toronto")
  
  # Get the current time in Toronto
  current_time <- Sys.time()
  
  # Format the current time
  formatted_time <- format(current_time, "%Y-%m-%d %H:%M")
  
  
  # Conditional to accomodate for either departures or arrivals
  if (flight_type == "departures") {
    data <- get_airlabs_api_response(key = "schedules", 
                                     parameter_name = "dep_iata", 
                                     parameter_value = airport) %>%
      
      
      group_by(arr_iata, dep_time) %>%
      mutate(row_to_keep = case_when(
        any(flight_number == cs_flight_number) ~ which(flight_number == cs_flight_number)[1],
        TRUE ~ 1
      )) %>%
      filter(row_number() == row_to_keep) %>%
      select(-row_to_keep) %>%
      
      # If running pre - 11am dep_actuals will be empty, so we will need a placeholder before calling select
      mutate(dep_actual = ifelse(exists("dep_actual"), dep_actual, NA)) %>%

      select(airline_iata, 
             dep_iata, dep_terminal, dep_time, dep_actual,
             dep_estimated, 
             arr_iata, #arr_time, arr_actual,
             delayed) %>%
      
      # Take dep_estimated by default if dep_actual does not exist
      # Take dep_estimated by default if dep_actual does not exist
      mutate(dep_actual = ifelse(is.na(dep_actual) & dep_estimated < formatted_time,
                                 dep_estimated, dep_actual)) %>%
      filter(!is.na(dep_actual)) 
    
    # Convert dep_actual and dep_time to POSIXct format
    data$dep_actual <- as.POSIXct(data$dep_actual)
    data$dep_time <- as.POSIXct(data$dep_time)
    
  } else if (flight_type == "arrivals") {
    data <- get_airlabs_api_response(key = "schedules", 
                                     parameter_name = "arr_iata", 
                                     parameter_value = airport) %>%
      
      group_by(dep_iata, arr_time) %>%
      mutate(row_to_keep = case_when(
        any(flight_number == cs_flight_number) ~ which(flight_number == cs_flight_number)[1],
        TRUE ~ 1
      )) %>%
      filter(row_number() == row_to_keep) %>%
      select(-row_to_keep) %>%
      
      # If running pre - 11am dep_actuals will be empty, so we will need a placeholder before calling select
      mutate(arr_actual = ifelse(exists("arr_actual"), arr_actual, NA)) %>%
      
      #arrange(dep_iata, arr_time) %>%
      #group_by(dep_iata, arr_time) %>%
      #filter(ifelse(n() > 1, flight_number == cs_flight_number, TRUE)) %>%
      
      #filter(flight_number == cs_flight_number) %>%
      #distinct(arr_iata, dep_time, .keep_all = TRUE) %>%
      dplyr::select(airline_iata, 
                    dep_iata, dep_time, dep_time_utc, dep_actual, 
                    arr_iata, arr_terminal, arr_time, arr_time_utc, arr_actual,
                    arr_estimated,
                    delayed) %>%
      
      # Take arr_estimated by default if arr_actual does not exist
      mutate(arr_actual = ifelse(is.na(arr_actual) & arr_estimated < formatted_time,
                                 arr_estimated, arr_actual)) %>%
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
  # This isused in the name of the data.
  current_minute <- format(current_time, "%d%m_%H%M")
  
  # Save the departures data
  
  # SHINY
  write.csv(data, paste0("Data/", flight_type, "/YYZ_", flight_type, "_", current_minute, ".csv"), row.names = FALSE)
  data_full <- combine_csv_files(paste0("Data/", flight_type), type = "delays")
  
  print(nrow(data_full))
  
  return(data_full)
  
}








# Use the live flight data to calculate proportion of flights which are:
# 1. On Time
# 2. Within 15 Mins of scheduled time
# 3. Late

delayed_percentage <- function(data, terminal_type) {
  
  # Conditional
  if (terminal_type == "dep") {
    data <- data %>%
      rename("terminal" = "dep_terminal") %>%
      rename("actual" =  "dep_actual") %>%
      rename("time" = "dep_time") %>%
      mutate(actual = as.POSIXct(actual, format = "%Y-%m-%d %H:%M:%S")) %>%
      mutate(time = as.POSIXct(time, format = "%Y-%m-%d %H:%M:%S")) %>%
      filter(!is.na(actual))
  } else if (terminal_type == "arr") {
    data <- data %>%
      rename("terminal" = "arr_terminal")%>%
      rename("actual" =  "arr_actual") %>%
      rename("time" = "arr_time") %>%
      mutate(actual = as.POSIXct(actual)) %>%
      mutate(time = as.POSIXct(time)) %>%
      filter(!is.na(actual))
  }
  
  # Use dplyr::summarise and tidyr::pivot_longer
  percentage_df <- data %>%
    #group_by(terminal) %>%
    dplyr::summarise(
      On_Time = sum(is.na(delayed)) / n() * 100,
      Within_15_Minutes = sum(actual - time <= 15) / n() * 100 - On_Time,
      Late = 100 - On_Time - Within_15_Minutes,
      Flights_On_Time = sum(is.na(delayed)),
      Flights_Within_15_Minutes = sum(actual - time <= 15) - Flights_On_Time, 
      Flights_Late = sum(actual - time > 15)
    ) %>%
    pivot_longer(
      cols = c(On_Time, Within_15_Minutes, Late),
      names_to = "Category",
      values_to = "Percentage"
    ) %>%
    pivot_longer(
      cols = starts_with("Flights_"),
      names_to = "Count",
      values_to = "Flights"
    ) %>%
    #filter(!is.na(terminal)) %>%
    mutate(Count = gsub("Flights_", "", Count)) %>%
    filter(Category == Count) %>%
    select(-Count) %>%
    #group_by(terminal) %>%
    mutate(Label = ifelse(Category == "Within_15_Minutes",
                          round(cumsum(Percentage), 0),
                          round(Percentage, 0))
    ) %>%
    ungroup() %>% # Add this line to remove grouping after calculations 
    mutate(Percentage = round(Percentage, 2))
  
  return(percentage_df)
  
}






# Return Donut chart, speedometer style - analyzing performance metrics

plot_donut_chart <- function(percentage_df, title) {
  
  # Combine "On_Time" and "Within_15_Minutes" categories and calculate sum
  percentage_df <- percentage_df %>%
    mutate(Category = ifelse(Category %in% c("On_Time", "Within_15_Minutes"), "Within_15_Mins", Category)) %>%
    group_by(Category) %>%
    summarise(Percentage = sum(Percentage), Flights = sum(Flights)) %>%
    mutate(Category = factor(Category, levels = c("Within_15_Mins", "Late")))
  
  
  donut_chart <- ggplot(percentage_df, aes(x = "", y = Percentage, fill = Category)) +
    geom_bar(width = 1, stat = "identity", color = "white") +
    coord_polar("y", start = 0) +
    scale_fill_manual(values = case_when(
      percentage_df$Percentage[2] > 70 ~ c("#98FB98", "white"),
      percentage_df$Percentage[2] > 60 ~ c("#FFD700", "white"),
      TRUE ~ c("#FF8C8C","white")
    )) +
    labs(title = paste("Percentage of Flight", title, "Within 15 Minutes, and Late"),
         x = NULL, y = NULL) +
    theme_void() +
    geom_hline(yintercept = c(40, 30), color = "blue", linetype = "dashed", size = 1) +
    geom_hline(yintercept = 0, color = "black", linetype = "solid", size = 1) +
    geom_point(x = -1, y = 0, shape = 21, fill = "white", size = 75) +
    geom_text(data = data.frame(y = c(40, 30), label = paste0(" ", c(60, 70), "%")),
              aes(x = 1.75, y = y, label = label),
              inherit.aes = FALSE,
              hjust = 0,
              color = "black",
              size = 4) +
    annotate("text", x = -1, y = 0, label = paste0(round(percentage_df$Percentage[2], 0), "%"), size = 17.5, 
             color = case_when(
               percentage_df$Percentage[2] > 70 ~ c("#98FB98"),
               percentage_df$Percentage[2] > 60 ~ c("#FFD700"),
               TRUE ~ c("#FF8C8C")
             )) +
    guides(fill = FALSE)
  
  
  print(donut_chart)
  return(donut_chart)
  
}






