class GoFish
  attr_accessor :round, :round_results, :deck, :players

  BASE_HAND_SIZE = 7

  def initialize(players = [], deck = Deck.new, round = 0, round_results = [])
    @deck = deck
    @players = players
    @round = round
    @round_results = round_results
  end

  def start!
    deck.shuffle!
    deal_cards!
  end

  def play_round!(target, request)
    target = players.find { |player| player.name == target }
    matching_cards = take_matching_cards(target, request)
    drawn_card = current_player.add_card_to_hand(deck.draw_card) if matching_cards.empty?
    self.round_results << RoundResult.new(current_player:, target:, request:, matching_cards:, drawn_card:)
    advance_round if matching_cards.empty? && drawn_card&.rank != request
  end

  def current_player
    players[round%players.count]
  end

  def opponents
    players - [ current_player ]
  end

  def advance_round
    self.round += 1
  end


  def self.from_json(json)
    players = json["players"].map do |player_hash|
      Player.from_json(player_hash)
    end
    deck = Deck.new(json["deck"]["cards"].map do |card_hash|
       Card.new(card_hash["rank"], card_hash["suit"])
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

  private

  def deal_cards!
    BASE_HAND_SIZE.times do
      players.each { |player| player.add_card_to_hand(deck.draw_card) }
    end
  end

  def take_matching_cards(target, request)
    matching_cards = target.matching_cards(request)
    target.hand -= matching_cards
    current_player.hand += matching_cards
    matching_cards
  end
end
