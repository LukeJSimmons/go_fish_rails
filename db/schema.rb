# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_25_141602) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "game_users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_users_on_game_id"
    t.index ["user_id"], name: "index_game_users_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "name", null: false
    t.integer "players_count", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "go_fish"
    t.integer "bots_count"
    t.integer "bot_difficulty"
    t.integer "winner_id"
    t.datetime "start_time", default: "2025-07-23 13:27:00"
    t.datetime "end_time"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "game_users", "games"
  add_foreign_key "game_users", "users"

  create_view "stats", sql_definition: <<-SQL
      SELECT users.id,
      users.username,
      row_number() OVER (ORDER BY (count(
          CASE users.id
              WHEN games.winner_id THEN 1
              ELSE NULL::integer
          END)) DESC) AS index,
      count(game_users.id) AS total_games,
      count(
          CASE users.id
              WHEN games.winner_id THEN 1
              ELSE NULL::integer
          END) AS total_wins,
      count(
          CASE users.id
              WHEN games.winner_id THEN NULL::integer
              ELSE 1
          END) AS total_losses,
      round((((count(
          CASE users.id
              WHEN games.winner_id THEN 1
              ELSE NULL::integer
          END))::double precision / (count(game_users.id))::double precision) * (100)::double precision)) AS win_ratio,
      sum((games.end_time - games.start_time)) AS time_played,
      min(games.start_time) AS first_game,
      max(games.start_time) AS last_game
     FROM ((users
       JOIN game_users ON ((users.id = game_users.user_id)))
       JOIN games ON ((games.id = game_users.game_id)))
    GROUP BY users.id, users.username;
  SQL
end
