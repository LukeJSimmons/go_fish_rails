class AddTotalWinsToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :total_wins, :integer
  end
end
