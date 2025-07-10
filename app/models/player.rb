class Player
  attr_accessor :hand, :books
  attr_reader :user_id, :name

  def initialize(user_id, name, hand = [], books = [])
    @user_id = user_id
    @hand = hand
    @name = name
    @books = books
  end

  def add_card_to_hand(card)
    return unless card.is_a? Card
    hand << card
    card
  end

  def matching_cards(request)
    hand.select { |card| card.rank == request }
  end

  def score_books_if_possible!
    books = hand.group_by(&:rank).values.select { |rank_cards| rank_cards.count == 4 }
    books.flatten.each { |card| hand.delete(card) }
    books.each { |book| self.books << book }
  end


  def self.from_json(json)
    user_id = json["user_id"]
    name = json["name"]
    hand = json["hand"].map do |card_hash|
       Card.new(card_hash["rank"], card_hash["suit"])
     end
    books = json["books"].map do |book|
      book.map { |card_hash| Card.new(card_hash["rank"], card_hash["suit"]) }
    end
    self.new(user_id, name, hand, books)
  end

  def as_json(*)
    {
      user_id: user_id,
      name: name,
      hand: hand,
      books: books
    }
  end

  def ==(other_player)
    user_id == other_player.user_id
  end
end
