class GoFish
  attr_reader :deck, :players
  attr_accessor :round, :round_results

  BASE_HAND_SIZE = 7

  def initialize(players = [], deck = Deck.new, round = 0, round_results = [])
    @deck = deck
    @players = players
    @round = round
    @round_results = round_results
  end

  def deal_cards!
    BASE_HAND_SIZE.times do
      players.each { |player| player.add_card_to_hand(deck.draw_card) }
    end
  end

  def play_round!(target, request)
    advance_round
    self.round_results << RoundResult.new(target:, request:)
  end

  def current_player
    players[round%players.count]
  end

  def advance_round
    self.round += 1
  end


  def self.from_json(json)
    players = json["players"].map do |player_hash|
      Player.from_json(player_hash)
    end
    deck = Deck.new(json["deck"]["cards"].map do |card_hash|
       Card.new(**card_hash.symbolize_keys)
     end)
    round_results = json["round_results"].map do |result_hash|
      RoundResult.from_json(result_hash)
    end
    self.new(players, deck, json["round"], round_results)
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
      round: round,
      deck: deck.as_json,
      round_results: round_results.map(&:as_json)
    }
  end
end
