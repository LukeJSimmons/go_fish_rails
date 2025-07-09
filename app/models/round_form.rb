class RoundForm
  include ActiveModel::Model
  attr_accessor :target, :request

  validates :target, presence: true
  validates :request, presence: true
end
