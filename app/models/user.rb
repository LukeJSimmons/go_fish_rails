class User < ApplicationRecord
  has_many :game_users, dependent: :destroy
  has_many :games, through: :game_users
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "email", "encrypted_password", "id", "id_value", "last_seen_at", "remember_created_at", "reset_password_sent_at", "reset_password_token", "time_played", "total_games", "total_wins", "updated_at", "username" ]
  end

  def add_game
    self.total_games += 1
    save!
  end

  def add_win
    self.total_wins += 1
    save!
  end

  ActivityThreshold = 5.minutes

  def active_now!
    time_since_last_activity = [ Time.now - last_seen_at, 0 ].max

    if time_since_last_activity <= ActivityThreshold
      self.time_played += time_since_last_activity
    end

    self.last_seen_at = Time.now
    save!
  end
end
