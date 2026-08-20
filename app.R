library(shiny)
library(bslib)
library(dplyr)
library(httr2)

get_leaderboard <- function() {
  tmp <- tempfile(fileext = ".rds")
  
  request(
    "https://raw.githubusercontent.com/montgomeryinman/bmw_tls_leaderboard/main/data/tls_leaderboard_data.rds"
  ) %>%
    req_perform(path = tmp)
  
  readRDS(tmp)
}

ui <- page_sidebar(
  title = "TLS Losers BMW Championship Leaderboard Tracker",
  sidebar = sidebar("TLS Leaderboard"),
  card(tableOutput("table"))
)

server <- function(input, output, session) {
  
  leaderboard_data <- get_leaderboard()
  
  output$table <- renderTable({
    leaderboard_data
  })
}

shinyApp(ui = ui, server = server)

