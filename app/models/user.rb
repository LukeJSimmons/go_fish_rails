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
end
