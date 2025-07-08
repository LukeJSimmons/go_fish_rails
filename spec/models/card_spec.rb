require_relative '../../app/models/card'

RSpec.describe Card do
  let(:card) { Card.new('A', 'H') }
  it 'has a rank' do
    expect(card).to respond_to :rank
  end
end
