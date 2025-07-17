class Bot < Player
  attr_reader :name, :difficulty

  @@number_of_bots ||= 0

  def initialize(name, difficulty, hand = [], books = [])
    @name = name
    @difficulty = difficulty
    @hand = hand
    @books = books
  end

  def request(target = nil)
    return hand.sample.rank if difficulty == 0
    matching_card(target) || hand.sample.rank
  end

  def self.generate_name
    @@number_of_bots += 1
    "Bot #{@@number_of_bots}"
  end

  def self.reset_number_of_bots
    @@number_of_bots = 0
  end

  def self.from_json(json)
    name = json["name"]
    difficulty = json["difficulty"]
    hand = json["hand"].map do |card_hash|
       Card.new(card_hash["rank"], card_hash["suit"])
     end
    books = json["books"].map do |book|
      book.map { |card_hash| Card.new(card_hash["rank"], card_hash["suit"]) }
    end
    self.new(name, difficulty, hand, books)
  end

  def as_json(*)
    {
      name: name,
      difficulty: difficulty,
      hand: hand,
      books: books
    }
  end

  private

  def matching_card(target)
    hand.find { |card| target.hand.map(&:rank).include? card.rank }&.rank
  end
end
