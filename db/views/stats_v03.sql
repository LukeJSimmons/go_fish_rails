SELECT
	users.id,
	username,
	ROW_NUMBER() OVER(ORDER BY COUNT(CASE users.id WHEN games.winner_id THEN 1 ELSE NULL END) DESC) as index,
	COUNT(game_users.id) AS total_games,
	COUNT(CASE users.id WHEN games.winner_id THEN 1 ELSE NULL END) AS total_wins,
	COUNT(CASE users.id WHEN games.winner_id THEN NULL ELSE 1 END) AS total_losses,
	ROUND((CAST(COUNT(CASE users.id WHEN games.winner_id THEN 1 ELSE NULL END) AS FLOAT) / CAST(COUNT(game_users.id) AS FLOAT)) * 100) AS win_ratio,
	SUM(games.end_time - games.start_time) AS time_played
FROM
	users
	INNER JOIN game_users ON users.id = game_users.user_id
	INNER JOIN games ON games.id = game_users.game_id
GROUP BY
	users.id,
	username