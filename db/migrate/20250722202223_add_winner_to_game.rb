class AddWinnerToGame < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :winner_id, :integer
  end
end
