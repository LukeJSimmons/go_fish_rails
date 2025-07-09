class RoundForm
  include ActiveModel::Model
  attr_accessor :target, :request, :game_id

  validates :target, presence: true
  validates :request, presence: true
end
