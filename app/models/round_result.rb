class RoundResult
  attr_reader :target, :request, :current_player, :matching_cards, :drawn_card, :scored_books

  def initialize(current_player:, target:, request:, matching_cards:, drawn_card:, scored_books:)
    @current_player = current_player
    @target = target
    @request = request
    @matching_cards = matching_cards
    @drawn_card = drawn_card
    @scored_books = scored_books
  end

  def player_action(recipient)
    "#{subject(recipient)} asked #{object(recipient)} for #{request}s"
  end

  def player_response(recipient)
     return "#{object(recipient)} didn't have any #{request}s" if matching_cards.empty?
     "You took #{matching_cards.count} #{request}s from #{object(recipient)}"
  end

  def game_response(recipient)
    return "#{subject(recipient)} drew a #{drawn_card.rank}" if drawn_card && recipient == current_player
    return "#{subject(recipient)} drew a card" if drawn_card
    "The deck is empty!" if matching_cards.empty?
  end

  def book_message(recipient, book)
    "#{subject(recipient)} scored a book of #{book.first.rank}s"
  end

  def self.from_json(json)
    target = Player.from_json(json["target"])
    request = json["request"]
    current_player = Player.from_json(json["current_player"])
    matching_cards = json["matching_cards"].map do |card_hash|
      Card.new(card_hash["rank"], card_hash["suit"])
    end
    drawn_card = json["drawn_card"] == nil ? nil : Card.new(json["drawn_card"]["rank"], json["drawn_card"]["suit"])
    scored_books = json["scored_books"].map do |book|
      book.map { |card_hash| Card.new(card_hash["rank"], card_hash["suit"]) }
    end
    self.new(target:, request:, current_player:, matching_cards:, drawn_card:, scored_books:)
  end

  def as_json(*)
    {
      current_player: current_player,
      target: target,
      request: request,
      matching_cards: matching_cards.map(&:as_json),
      drawn_card: drawn_card,
      scored_books: scored_books
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
