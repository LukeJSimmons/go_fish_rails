class AddDifficultyToGame < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :bot_difficulty, :integer
  end
end
