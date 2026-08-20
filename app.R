library(shiny)
library(bslib)
library(tidyverse)
library(golfastr)

#holes <- load_holes(2026, "BMW Championship", top_n = 10)

teamOwners_golferPairs <- 
  data.frame(
    owner = c("Craig", "Ryan", "Mont", "Chris", "BWenz", "Jordan",
              "Charlie", "Franco", "Justin", "Tyler", "Nate", "Luke"),
    player_name = c("Scottie Scheffler", "Rory McIlroy", "Xander Schauffele", "Ludvig Åberg", "Sam Burns",
               "Cameron Young", "Tommy Fleetwood", "Matt Fitzpatrick", "Si Woo Kim", "Hideki Matsuyama", "Chris Gotterup", 
               "Viktor Hovland")
  )

load_leaderboard(
  year = as.integer(format(Sys.Date(), "%Y")),
  tournament = "BMW Championship",
  tour = "pga"
) %>% 
  filter(
  player_name %in% teamOwners_golferPairs$player_name
) %>% 
  saveRDS(file = "tls_leaderboard_data.rds")

tls_leaderboard_data <- load_from_rds(file_path = "tls_leaderboard_data.rds")

tls_leaderboard_data <- tls_leaderboard_data %>%
  left_join(teamOwners_golferPairs, by = "player_name") %>%
  select(
    position, player_name, owner, total_score, score_to_par
  ) 

ui <- page_sidebar(
  title = "TLS Losers BMW Championship Leaderboard Tracker",
  sidebar = sidebar("TLS Leaderboard"),
  card(tableOutput("table"))
)


server <- function(input, output) {
  output$table <- renderTable({
    tls_leaderboard_data
  })
}

shinyApp(ui = ui, server = server)















