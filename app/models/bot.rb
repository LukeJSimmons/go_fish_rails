class Bot < Player
  attr_reader :name

  @@number_of_bots ||= 0

  def request
    hand.sample.rank
  end

  def self.generate_name
    @@number_of_bots += 1
    "Bot #{@@number_of_bots}"
  end

  def self.reset_number_of_bots
    @@number_of_bots = 0
  end
end
