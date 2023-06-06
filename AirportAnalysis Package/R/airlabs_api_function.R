



#' AirLabs API Function
#'
#' This function sends a request to the AirLabs API and returns the response as a data frame.
#'
#' @param key The API key for accessing the AirLabs API.
#' @param parameter_name Name of the first parameter to include in the API request.
#' @param parameter_value Value of the first parameter.
#' @param parameter_name2 Name of the second parameter to include in the API request.
#' @param parameter_value2 Value of the second parameter.
#'
#' @return A data frame containing the response from the AirLabs API.
#' @export
#'
#' @import httr
#' @import jsonlite
#'
#' @examples
#' # Retrieve data from the AirLabs API
#' data <- airlabs_api_function(key = "your_api_key", parameter_name = "parameter1", parameter_value = "value1",
#'                              parameter_name2 = "parameter2", parameter_value2 = "value2")




#Airlabs API function

# Use this function to query the airlabs api
# See documentation for info on varying endpoints
# Endpoint is configured with the "key" argument - examples include, "schedules", "flights"
# specify additional parameters - 
# Sometimes certain params are required, eg. for schedules you must specify airport code etc.
# https://airlabs.co/docs/schedules




# core api function
airlabs_api_function <- function(key, parameter_name = "parameter1", parameter_value = "value1",
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

