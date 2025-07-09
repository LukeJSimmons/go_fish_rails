require_relative "./player"

class Game < ApplicationRecord
  has_many :game_users, dependent: :destroy
  has_many :users, through: :game_users

  validates :name, presence: true
  validates :players_count, numericality: true

  serialize :go_fish, coder: GoFish

  def start!
    return unless users.count == players_count
    players = users.map { |user| Player.new(user.id) }
    self.go_fish = GoFish.new(players)
    go_fish.deal_cards!
    save!
  end

  def get_player_by_user(user)
    go_fish.players.find { |player| player.user_id == user.id }
  end
end
