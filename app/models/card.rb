class Card
  attr_reader :rank, :suit

  RANKS = %w[A 2 3 4 5 6 7 8 9 10 J Q K]
  SUITS = %w[H D S C]

  def initialize(rank:, suit:)
    @rank = rank
    @suit = suit

    raise_error StandardError unless RANKS.include? rank
    raise_error StandardError unless SUITS.include? suit
  end
end
