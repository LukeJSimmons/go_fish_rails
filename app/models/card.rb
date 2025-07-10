class Card
  attr_reader :rank, :suit, :value

  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A]
  SUITS = %w[H D S C]

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
    @value = RANKS.find_index(rank)

    raise_error StandardError unless RANKS.include? rank
    raise_error StandardError unless SUITS.include? suit
  end

  def ==(other_card)
    rank == other_card.rank &&
    suit == other_card.suit
  end

  def <=>(other_card)
    value <=> other_card.value
  end

  def as_json(*)
    {
      rank: rank,
      suit: suit
    }
  end
end
