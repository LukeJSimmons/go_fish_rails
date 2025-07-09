class RoundResult
  attr_reader :target, :request, :current_player

  def initialize(current_player:, target:, request:)
    @current_player = current_player
    @target = target
    @request = request
  end

  def player_action(recipient)
    "#{subject(recipient)} asked #{target.name} for #{request}s"
  end

  def player_response(recipient)
    "#{target.name} didn't have any #{request}s"
  end

  def game_response(recipient)
    "#{subject(recipient)} drew a 10"
  end

  def self.from_json(json)
    target = Player.from_json(json["target"])
    request = json["request"]
    current_player = Player.from_json(json["current_player"])
    self.new(target:, request:, current_player:)
  end

  def as_json(*)
    {
      current_player: current_player,
      target: target,
      request: request
    }
  end

  private

  def subject(recipient)
    recipient == current_player ? "You" : current_player.name
  end
end
