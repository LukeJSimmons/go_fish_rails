require_relative "./player"

class Game < ApplicationRecord
  has_many :game_users, dependent: :destroy
  has_many :users, through: :game_users

  validates :name, presence: true
  validates :players_count, numericality: true

  serialize :go_fish, coder: GoFish

  def start_if_possible!
    return unless users.count == players_count
    players = users.map { |user| Player.new(user.id, user.username) }
    self.go_fish = GoFish.new(players) unless go_fish
    go_fish.start!
    save!
  end

  def play_round!(target, request)
    go_fish.play_round!(target, request)
    save!
  end

  def winner
    go_fish.winner
  end

  def game_over?
    go_fish.game_over?
  end

  def current_player
    go_fish.current_player
  end

  def opponents(current_user)
    go_fish.players - [ get_player_by_user(current_user) ]
  end

  def get_player_by_user(user)
    go_fish.players.find { |player| player.user_id == user.id }
  end
end
