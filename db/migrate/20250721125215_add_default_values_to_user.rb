class AddDefaultValuesToUser < ActiveRecord::Migration[8.0]
  def change
    change_column :users, :total_games, :integer, default: 0
    change_column :users, :total_wins, :integer, default: 0
  end
end
