class RoundResult
  attr_reader :target, :request, :current_player, :matching_cards, :fished_card, :scored_books, :drawn_cards

  def initialize(current_player:, target:, request:, matching_cards:, fished_card:, scored_books:, drawn_cards:)
    @current_player = current_player
    @target = target
    @request = request
    @matching_cards = matching_cards
    @fished_card = fished_card
    @scored_books = scored_books
    @drawn_cards = drawn_cards
  end

  def player_action(recipient)
    "#{subject(recipient)} asked #{object(recipient)} for #{request}s"
  end

  def player_response(recipient)
     return "#{object(recipient)} didn't have any #{request}s" if matching_cards.empty?
     "You took #{matching_cards.count} #{request}s from #{object(recipient)}"
  end

  def game_response(recipient)
    return draw_card_message(recipient, fished_card) if fished_card
    "The deck is empty!" if matching_cards.empty?
  end

  def draw_card_message(recipient, card)
    recipient == current_player ?
    "#{subject(recipient)} drew a #{card.rank}" :
    "#{subject(recipient)} drew a card" if card
  end

  def book_message(recipient, book)
    "#{subject(recipient)} scored a book of #{book.first.rank}s"
  end

  def self.from_json(json)
    target, request = Player.from_json(json["target"]), json["request"]
    current_player = Player.from_json(json["current_player"])
    matching_cards = json["matching_cards"].map { |card_hash| Card.new(card_hash["rank"], card_hash["suit"]) }
    fished_card = Card.from_json(json["fished_card"]) if json["fished_card"]
    scored_books = json["scored_books"].map { |book| book.map { |card_hash| Card.new(card_hash["rank"], card_hash["suit"]) } }
    drawn_cards = json["drawn_cards"]
    self.new(target:, request:, current_player:, matching_cards:, fished_card:, scored_books:, drawn_cards:)
  end

  def as_json(*)
    {
      current_player: current_player,
      target: target,
      request: request,
      matching_cards: matching_cards.map(&:as_json),
      fished_card: fished_card.as_json,
      scored_books: scored_books,
      drawn_cards: drawn_cards
    }
  end

  private

  def subject(recipient)
    recipient == current_player ? "You" : current_player.name
  end

  def object(recipient)
    recipient == target ? "You" : target.name
  end
end
