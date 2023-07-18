



# TODO:
# - Tidy input files into one "combined"
# - Change the way "actuals" and "estimated" are calculated...
# - Automate data collection now I have new laptop...


# read.csv("Shiny/Data/departures/YYZ_departures_1206_1802.csv")
# 
# date <- "2023-06-12"
# time <- 0
# sprintf("%s %s:00:00", date, time)


server <- function(input, output, session) {
  
  
  # Create a reactiveValues object to track the button state
  buttonState <- reactiveValues(clicked = 0)
  
  # Variable to store the last time departures_dd() was called
  lastUpdateTime <- reactiveVal(as.POSIXct("1970-01-01", origin = "1970-01-01", tz = "UTC"))
  
  
  
  # Fetch live flight data for departures and arrivals
  departures_dd <- eventReactive(input$updateButton, {
    
    # Store the current time as the last update time
    lastUpdateTime(Sys.time())
    get_live_flight_data("departures", "YYZ")
    
  })
  
  
  # # Fetch live flight data for departures and arrivals
  # departures_dd <- reactive({
  #   
  #   # Update flight data when button is clicked
  #   buttonState$clicked
  #   
  #   # Store the current time as the last update time
  #   lastUpdateTime(Sys.time())
  #   
  #   get_live_flight_data("departures", "YYZ")
  # })
  
  # Fetch live flight data for departures and arrivals
  arrivals_dd <- eventReactive(input$updateButton, {
    
    # Store the current time as the last update time
    lastUpdateTime(Sys.time())
    get_live_flight_data("arrivals", "YYZ")
    
  })
  
  
  
  # arrivals_dd <- reactive({
  #   
  #   # Update flight data when button is clicked
  #   buttonState$clicked
  #   
  #   get_live_flight_data("arrivals", "YYZ")
  #   
  # })
  
  # Calculate delay percentages for departures and arrivals
  departure_percentages <- reactive({
    delayed_percentage(filtered_departures(), "dep")
  })
  
  arrival_percentages <- reactive({
    delayed_percentage(filtered_arrivals(), "arr")
  })
  
  # Filter the data based on dep_time for departures
  filtered_departures <- reactive({
    
    req(departures_dd())
    
    dep_range_start <- sprintf("%s %02d:00:00", input$dateRange[1], input$timeRange[1])
    dep_range_end <- sprintf("%s %02d:00:00", input$dateRange[2], input$timeRange[2])
    
    
    if ("No Record" %in% input$terminalFilter) {
      filtered_data <- departures_dd() %>%
        filter((dep_terminal %in% input$terminalFilter) | (dep_terminal == "") | is.na(dep_terminal),
               dep_time >= dep_range_start, dep_time <= dep_range_end) %>%
        arrange(dep_time)
    } else {
      filtered_data <- departures_dd() %>%
        filter(dep_terminal %in% input$terminalFilter,
               dep_time >= dep_range_start, dep_time <= dep_range_end) %>%
        arrange(dep_time)
    }
    if (input$airlineFilter == "Air Canada") {
      filtered_data <- filtered_data %>%
        filter(airline_name == "Air Canada")
    }
    
    
    
    filtered_data
  })
  
  # Filter the data based on dep_time for arrivals
  filtered_arrivals <- reactive({
    
    req(arrivals_dd())
    
    arr_range_start <- sprintf("%s %02d:00:00", input$dateRange[1], input$timeRange[1])
    arr_range_end <- sprintf("%s %02d:00:00", input$dateRange[2], input$timeRange[2])
    
    
    if ("No Record" %in% input$terminalFilter) {
      filtered_data <- arrivals_dd() %>%
        filter((arr_terminal %in% input$terminalFilter) | (arr_terminal == "") | is.na(arr_terminal),
               arr_time >= arr_range_start, arr_time <= arr_range_end) %>%
        arrange(arr_time)
    } else {
      filtered_data <- arrivals_dd() %>%
        filter(arr_terminal %in% input$terminalFilter,
               arr_time >= arr_range_start, arr_time <= arr_range_end) %>%
        arrange(arr_time)
    }
    # One extra step for airline
    if (input$airlineFilter == "Air Canada") {
      filtered_data <- filtered_data %>%
        filter(airline_name == "Air Canada")
    }
    
    filtered_data
  })
  
  # Render the departure plot
  output$departurePlot <- renderPlot({
    plot_donut_chart(departure_percentages(), "Departures")
  })
  
  # Render the arrival plot
  output$arrivalPlot <- renderPlot({
    plot_donut_chart(arrival_percentages(), "Arrivals")
  })
  
  # Render the filtered table
  output$filteredTable <- renderDataTable({
    if (input$flightType == "Departures") {
      datatable(
        filtered_departures() %>%
          select(airline_name,
                 destination = airport_name, 
                 dep_terminal, dep_time, dep_actual, delayed),
        options = list(pageLength = 5)  # Show 5 entries per page
      )
    } else if (input$flightType == "Arrivals") {
      datatable(
        filtered_arrivals() %>%
          select(airline_name, 
                 origin = dep_iata, 
                 arr_terminal, arr_time, arr_actual, delayed),
        options = list(pageLength = 5)  # Show 5 entries per page
      )
    }
  })
  
  
  
  # Update update clicker to local time, tz america/toronto
  output$lastUpdateTime <- renderText({
    lastUpdateTimeFormatted <- format(lastUpdateTime(), "%Y-%m-%d %H:%M:%S", tz = "UTC")
    lastUpdateTimeLocal <- format(as.POSIXct(lastUpdateTimeFormatted, tz = "UTC"), tz = "America/Toronto")
    HTML(paste("<span style='color:blue; font-size:20px;'>Last Updated: ", lastUpdateTimeLocal, "</span>"))
  })
  
  # Update the lastUpdateTime value with the formatted date when departures_dd() is called
  observeEvent(departures_dd(), {
    lastUpdateTime(Sys.time())
  })
  
  
  
  # Get available dates for departures and arrivals
  #available_dates <- reactive({
  #  unique(departures_dd()$dep_time %>% as.Date())
  #  
  #})
  
  
  # Add an actionButton to trigger the data update
  observeEvent(input$updateButton, {
    
    buttonState$clicked <- buttonState$clicked + 1  # Increment clicked value to trigger data update
    
  })
  
  # Automatically click the button every 30 minutes
  observe({
    invalidateLater(30 * 60 * 1000, session)  # Invalidates the observer every 5 minutes
    isolate({
      buttonState$clicked <- buttonState$clicked + 1  # Increment clicked value to trigger data update
    })
  })
  
  
  # Update Date Range input here
  observe({
    if (!is.null(departures_dd())) {

      # Update flight data when button is clicked
      buttonState$clicked
      
      available_dates <- unique(departures_dd()$dep_time %>% as.Date())
      
      updateDateRangeInput(
        session,
        "dateRange",
        start = available_dates[length(available_dates)],
        end = available_dates[length(available_dates)],
        min = available_dates[1],
        max = available_dates[length(available_dates)]
      )
      shinyjs::enable("dateRange")
    } else {
      shinyjs::disable("dateRange")
    }
  })
  
  
  
  # Automatically click the button when the app starts
  shinyjs::runjs("$('#updateButton').click();")

}





