library(shiny)
library(bslib)
library(tidyverse)
library(golfastr)

teamOwners_golferPairs <- data.frame(
  owner = c("Craig", "Ryan", "Mont", "Chris", "BWenz", "Jordan",
            "Charlie", "Franco", "Justin", "Tyler", "Nate", "Luke"),
  player_name = c("Scottie Scheffler", "Rory McIlroy", "Xander Schauffele", "Ludvig Åberg", "Sam Burns",
                  "Cameron Young", "Tommy Fleetwood", "Matt Fitzpatrick", "Si Woo Kim",
                  "Hideki Matsuyama", "Chris Gotterup", "Viktor Hovland")
)

get_leaderboard <- function() {
  load_leaderboard(
    year = as.integer(format(Sys.Date(), "%Y")),
    tournament = "BMW Championship",
    tour = "pga"
  ) %>%
    filter(player_name %in% teamOwners_golferPairs$player_name) %>%
    left_join(teamOwners_golferPairs, by = "player_name") %>%
    select("Pos" = position, 
           "Player" = player_name, 
           "Owner" = owner, 
           "Total Score" = total_score, 
           "To Par" score_to_par)
}

ui <- page_sidebar(
  title = "TLS Losers BMW Championship Leaderboard Tracker",
  sidebar = sidebar("TLS Leaderboard"),
  card(tableOutput("table"))
)

server <- function(input, output, session) {
  leaderboard_data <- reactivePoll(
    intervalMillis = 60000,           # check every 60s — tune to taste
    session = session,
    checkFunc = function() Sys.time(),  # always re-check; swap for something cheaper if you have it
    valueFunc = get_leaderboard
  )
  
  output$table <- renderTable({
    leaderboard_data()
  })
}

shinyApp(ui = ui, server = server)















