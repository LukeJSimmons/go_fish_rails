class Player
  attr_accessor :hand
  attr_reader :user_id

  def initialize(user_id, hand = [])
    @user_id = user_id
    @hand = hand
  end

  def add_card_to_hand(card)
    hand << card
  end


  def self.from_json(json)
    user_id = json["user_id"]
    hand = json["hand"]
    self.new(user_id, hand)
  end
end
