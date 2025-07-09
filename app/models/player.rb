class Player
  attr_accessor :hand
  attr_reader :user_id, :name

  def initialize(user_id, name, hand = [])
    @user_id = user_id
    @hand = hand
    @name = name
  end

  def add_card_to_hand(card)
    hand << card
  end


  def self.from_json(json)
    user_id = json["user_id"]
    name = json["name"]
    hand = json["hand"].map do |card_hash|
       Card.new(**card_hash.symbolize_keys)
     end
    self.new(user_id, name, hand)
  end

  def as_json(*)
    {
      user_id: user_id,
      name: name,
      hand: hand
    }
  end

  def ==(other_player)
    user_id == other_player.user_id
  end
end
