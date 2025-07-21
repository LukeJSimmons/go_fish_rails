class AddTimePlayedToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :time_played, :float
  end
end
