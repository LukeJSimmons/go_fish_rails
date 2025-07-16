class Bot
  attr_reader :name

  def initialize
    @name = generate_name
  end

  private

  def generate_name
    "Bot"
  end
end
