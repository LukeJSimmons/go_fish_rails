require_relative "./player"

class Game < ApplicationRecord
  include ActionView::RecordIdentifier

  has_many :game_users, dependent: :destroy
  has_many :users, through: :game_users

  validates :name, presence: true
  validates :players_count, numericality: true
  validates :bots_count, numericality: true
  validates :bot_difficulty, numericality: true

  serialize :go_fish, coder: GoFish

  broadcasts_refreshes

  def start_if_possible!
    return unless users.count == players_count
    users.map { |user| user.add_game }
    players = users.map { |user| Player.new(user.username, user.id) }
    players += bots_count.times.each_with_index.map { |bot, index| Bot.new("Bot #{index+1}", bot_difficulty) }
    self.go_fish = GoFish.new(players:) unless go_fish
    go_fish.start!
    save!
  end

  def play_round!(target, request)
    go_fish.play_round!(target, request)
    save!
  end

  def winner
    User.find(go_fish.winner.user_id).add_win if go_fish.winner.instance_of? Player
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
