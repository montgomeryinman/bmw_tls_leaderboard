library(shiny)
library(bslib)
library(httr2)

get_leaderboard <- function() {
  
  tmp <- tempfile(fileext = ".rds")
  
  url <- paste0(
    "https://raw.githubusercontent.com/montgomeryinman/bmw_tls_leaderboard/main/data/tls_leaderboard_data.rds?",
    as.numeric(Sys.time())
  )
  
  request(url) |>
    req_perform(path = tmp)
  
  readRDS(tmp)
}

ui <- page_sidebar(
  title = "TLS Losers BMW Championship Leaderboard Tracker",
  
  sidebar = sidebar(
    "TLS Leaderboard"
  ),
  
  card(
    tableOutput("table")
  )
)

server <- function(input, output, session) {
  
  leaderboard_data <- reactiveVal(get_leaderboard())
  
  observe({
    invalidateLater(60 * 1000, session)
    
    tryCatch(
      leaderboard_data(get_leaderboard()),
      error = function(e) {
        message("Failed to update leaderboard: ", e$message)
      }
    )
  })
  
  output$table <- renderTable({
    leaderboard_data()
  })
}

shinyApp(ui = ui, server = server)
