class GoFish
  attr_accessor :round, :round_results, :deck, :players

  BASE_HAND_SIZE = 7

  def initialize(players: [], deck: Deck.new, round: 0, round_results: [])
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
    fished_card = current_player.add_card_to_hand(deck.draw_card) if matching_cards.empty? && !deck.empty?
    scored_books = current_player.score_books_if_possible!
    drawn_cards = !deck.empty? && players.any? { |player| player.hand.empty? } ? draw_cards_if_needed : {}
    self.round_results << RoundResult.new(current_player:, target:, request:, matching_cards:, fished_card:, scored_books:, drawn_cards:)
    advance_round if (matching_cards.empty? && fished_card&.rank != request) || current_player.hand.empty?
  end

  def current_player
    players[round%players.count]
  end

  def opponents
    players - [ current_player ]
  end

  def advance_round
    self.round += 1
    return self.round += 1 until current_player.hand.any? if current_player.hand.empty?
    play_bot_rounds if current_player.is_a? Bot
  end

  def winner
    return player_with_most_books unless tie?
    player_with_highest_rank_book
  end

  def game_over?
    deck.empty? && players.map(&:hand).all?(&:empty?)
  end


  def self.from_json(json)
    players = json["players"].map { |player_hash| player_hash["user_id"] == nil ? Bot.from_json(player_hash) : Player.from_json(player_hash) }
    deck = Deck.new(json["deck"]["cards"].map { |card_hash| Card.new(card_hash["rank"], card_hash["suit"]) })
    round = json["round"]
    round_results = json["round_results"].map { |result_hash| RoundResult.from_json(result_hash) }
    self.new(players:, deck:, round:, round_results:)
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

  def draw_cards_if_needed
    players_with_empty_hands = players.select { |player| player.hand.empty? }
    players_drawn_cards = players_with_empty_hands.map { |player| [ player, player.add_card_to_hand(deck.draw_card) ] }
    Hash[players_drawn_cards]
  end

  def tie?
    total_books = players.map(&:books).map(&:count)
    total_books.all? { |books_count| books_count == total_books.first }
  end

  def player_with_most_books
    total_books = players.map(&:books).map(&:count)
    players[total_books.find_index(total_books.max)]
  end

  def player_with_highest_rank_book
    players_highest_books = players.map do |player|
      player.books.map(&:first).map(&:value).max
    end
    players[players_highest_books.find_index(players_highest_books.max)]
  end

  def play_bot_rounds
    play_bot_round until current_player.instance_of? Player
  end

  def play_bot_round
    return advance_round if current_player.hand.empty?
    target = opponents.sample
    play_round!(target.name, current_player.request(target))
  end
end
