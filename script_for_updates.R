#teamOwners_golferPairs <- data.frame(
#  owner = c("Craig", "Ryan", "Mont", "Chris", "BWenz", "Jordan",
#            "Charlie", "Franco", "Justin", "Tyler", "Nate", "Luke"),
#  player_name = c("Scottie Scheffler", "Rory McIlroy", "Xander Schauffele", "Ludvig Åberg", "Sam Burns",
#                  "Cameron Young", "Tommy Fleetwood", "Matt Fitzpatrick", "Si Woo Kim",
#                  "Hideki Matsuyama", "Chris Gotterup", "Viktor Hovland")
#) %>% saveRDS(file = "data/pairs.RDS")

library(dplyr)
library(golfastr)

pairs <- readRDS("data/pairs.RDS")

leaderboard_data <- load_leaderboard(2026, "401811963") %>%
  filter(player_name %in% pairs$player_name) %>%
  left_join(pairs, by = "player_name") %>%
  select(
    "Pos" = position,
    "Player" = player_name,
    "Owner" = owner,
    "Total Score" = total_score,
    "To Par" = score_to_par
  )

saveRDS(
  leaderboard_data,
  "data/tls_leaderboard_data.rds"
)
