


ui <- dashboardPage(
  dashboardHeader(title = "YYZ Departures and Arrivals Performance"),
  dashboardSidebar(
    width = 300,  # Adjust the width here
    sidebarMenu(
      dateRangeInput(
        "dateRange",
        "Select Date Range",
        start = Sys.Date() - 7,
        end = Sys.Date(),
        min = as.character(Sys.Date() - 30),
        max = as.character(Sys.Date())
      ),
      sliderInput(
        "timeRange",
        "Select Time Range",
        min = 0,
        max = 24,
        value = c(0, 24),
        step = 1,
        animate = FALSE
      ),
      selectInput(
        "dataType",
        "Select Data Type",
        choices = c("Departures", "Arrivals"),
        selected = "Departures"
      ),
      actionButton(
        "updateButton",
        "Update",
        class = "btn-primary",
        style = "width: 100%; margin-top: 10px;"
      )
    )
  ),
  dashboardBody(
    useShinyjs(),
    fluidRow(
      box(
        width = 6,
        title = "Departures",
        plotOutput("departurePlot")
      ),
      box(
        width = 6,
        title = "Arrivals",
        plotOutput("arrivalPlot")
      )
    ),
    fluidRow(
      box(
        width = 12,
        htmlOutput("lastUpdateTime")
      )
    ),
    fluidRow(
      box(
        width = 12,
        withSpinner(dataTableOutput("filteredTable"))
      )
    )
  )
)
