SELECT
  username,
  total_games,
  total_wins,
  total_games - total_wins AS total_losses,
  time_played
FROM users