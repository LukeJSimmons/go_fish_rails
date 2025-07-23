class AddStartTimeAndEndTimeToGames < ActiveRecord::Migration[8.0]
  def change
    add_column :games, :start_time, :datetime, default: Time.now
    add_column :games, :end_time, :datetime
  end
end
