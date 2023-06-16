


ui <- fluidPage(
  useShinyjs(),
  
  # Define the sidebar layout
  sidebarLayout(
    sidebarPanel(
      div(
        style = "padding: 10px;",
        tags$img(
          src = "https://img1.wsimg.com/isteam/ip/88c64e13-58fe-44b6-979c-b80c4986ddff/logo%20final%20(2).jpg",
          width = "120px",
          height = "90px"
        ),
        titlePanel(
          tags$h1("YYZ Departures and Arrivals Performance", style = "margin-bottom: 0;")
        ),
        tags$hr(),  # Add a horizontal line
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
          "flightType",
          "Filter by Departures / Arrivals",
          choices = c("Departures", "Arrivals"),
          selected = "Departures"
        ),
        # Terminals
        checkboxGroupInput(
          "terminalFilter",
          "Filter by Terminal",
          choices = c("1", "3", "No Record"),  # Replace with your desired terminal options
          selected = c("1", "3")
        ),
        
        # Airlines
        selectInput(
          "airlineFilter",
          "Filter by Airline",
          choices = c("All", "Air Canada"),
          multiple = FALSE,
          selected = "All"
        ),
        
        tags$hr(),
        actionBttn(
          inputId = "updateButton",
          label = "Update",
          style = "gradient",
          color = "primary",
          size = "md",
          width = "100%"#,
          #style = "margin-top: 10px;"
        )
      )
    ),
    
    # Define the main panel layout
    mainPanel(
      tags$br(), 
      tags$hr(),
      fluidRow(
        column(width = 6, plotOutput("departurePlot")),
        column(width = 6, plotOutput("arrivalPlot"))
      ), 
      htmlOutput("lastUpdateTime"),
      tags$br(),  # Add a physical line break
      tags$hr(),
      #withSpinner(dataTableOutput("filteredTable"))
      dataTableOutput("filteredTable")
    )
  )
)



