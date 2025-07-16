class AddBotsCountToGame < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :bots_count, :integer
  end
end
