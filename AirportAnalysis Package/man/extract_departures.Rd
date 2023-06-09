% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/extract_departures.R
\name{extract_departures}
\alias{extract_departures}
\title{Extract departures}
\usage{
extract_departures(parameter_value, date = NULL)
}
\arguments{
\item{parameter_value}{The airport code for which to extract and analyze data.}
}
\value{
A data frame containing the deep dive analysis results for the specified airport.
}
\description{
This function performs data extraction, handling, and deep dive analysis on scheduled departures data
for a specific airport.
}
\examples{
# Extract and analyze data for LAX airport
data <- extract_departures(parameter_value = "LAX")
# Extract and analyze data for LHR airport
data <- extract_departures(parameter_value = "LHR")
}
