class RemoveStatsInfoFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :total_games
    remove_column :users, :total_wins
    remove_column :users, :time_played
    remove_column :users, :last_seen_at
  end
end
