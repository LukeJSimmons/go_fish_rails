require_relative "./deck"

class GoFish
  attr_reader :deck, :players, :current_player_index

  BASE_HAND_SIZE = 7

  def initialize(players = [], deck = Deck.new, current_player_index = 0)
    @deck = deck
    @players = players
    @current_player_index = current_player_index
  end

  def deal_cards!
    BASE_HAND_SIZE.times do
      players.each { |player| player.add_card_to_hand(deck.draw_card) }
    end
  end


  def self.from_json(json)
    players = json["players"].map do |player_hash|
      Player.from_json(player_hash)
    end
    deck = Deck.new(json["deck"]["cards"].map do |card_hash|
       Card.new(**card_hash.symbolize_keys)
     end)
    self.new(players, deck, json["current_player_index"])
  end

  def self.load(json)
    return nil if json.blank?
    self.from_json(json)
  end

  def self.dump(obj)
    obj.as_json
  end

  def as_json(*)
    {
      players: players.map(&:as_json),
      current_player_index: current_player_index,
      deck: deck.as_json
    }
  end
end
