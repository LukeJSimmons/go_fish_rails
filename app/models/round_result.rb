class RoundResult
  attr_reader :target, :request, :current_player, :matching_cards

  def initialize(current_player:, target:, request:, matching_cards:)
    @current_player = current_player
    @target = target
    @request = request
    @matching_cards = matching_cards
  end

  def player_action(recipient)
    "#{subject(recipient)} asked #{target.name} for #{request}s"
  end

  def player_response(recipient)
     return "#{target.name} didn't have any #{request}s" if matching_cards.empty?
     "You took #{matching_cards.count} #{request}s from #{target.name}"
  end

  def game_response(recipient)
    "#{subject(recipient)} drew a 10"
  end

  def self.from_json(json)
    target = Player.from_json(json["target"])
    request = json["request"]
    current_player = Player.from_json(json["current_player"])
    matching_cards = json["matching_cards"].map do |card_hash|
      Card.new(card_hash["rank"], card_hash["suit"])
    end
    self.new(target:, request:, current_player:, matching_cards:)
  end

  def as_json(*)
    {
      current_player: current_player,
      target: target,
      request: request,
      matching_cards: matching_cards.map(&:as_json)
    }
  end

  private

  def subject(recipient)
    recipient == current_player ? "You" : current_player.name
  end
end
