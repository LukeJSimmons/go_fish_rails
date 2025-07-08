require_relative "./card"

class Deck
  attr_reader :cards

  BASE_DECK_SIZE = 52

  def initialize(cards = Array.new(52, Card.new("A", "H")))
    @cards = cards
  end

  def cards_left
    cards.count
  end

  def draw_card
    cards.pop
  end
end
