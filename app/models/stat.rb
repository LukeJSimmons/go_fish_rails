class Stat < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    [ "index", "username", "total_wins", "total_losses", "total_games", "win_ratio", "time_played" ]
  end

  def readonly?
    true
  end
end
