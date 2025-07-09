require_relative "./card"

class Deck
  attr_reader :cards

  BASE_DECK_SIZE = 52

  def initialize(cards = build_cards)
    @cards = cards
  end

  def cards_left
    cards.count
  end

  def draw_card
    cards.pop
  end

  private

  def build_cards
    Card::RANKS.flat_map do |rank|
      Card::SUITS.map do |suit|
        Card.new(rank:, suit:)
      end
    end
  end
end
