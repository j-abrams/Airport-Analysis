#' @name airports
#' @title Airport lookup codes
#' @docType data
#' @format A data frame with airport lookup codes
#' @description This dataset contains lookup codes for airports.
#' @export
airports <- read.csv(system.file("data", "airports.csv", package = "AirportAnalysis"), stringsAsFactors = FALSE) %>%
  select(-X)

#' @name airlines
#' @title Airline lookup codes
#' @docType data
#' @format A data frame with airline lookup codes
#' @description This dataset contains lookup codes for airlines.
#' @export
airlines <- read.csv(system.file("data", "airlines.csv", package = "AirportAnalysis"), stringsAsFactors = FALSE) %>%
  select(-X)
