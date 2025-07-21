class AddTotalGamesToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :total_games, :integer
  end
end
