class RoundResult
  attr_reader :target, :request

  def initialize(target:, request:)
    @target = target
    @request = request
  end

  def self.from_json(json)
    self.new(**json.symbolize_keys)
  end
end
