require_relative '../../app/models/go_fish'

RSpec.describe GoFish do
  let(:go_fish) { GoFish.new }
  it 'has a deck' do
    expect(go_fish).to respond_to :deck
    expect(go_fish.deck).to be_a Deck
  end

  it 'has players' do
    expect(go_fish).to respond_to :players
  end

  it 'has a current_player_index' do
    expect(go_fish).to respond_to :current_player_index
  end
end
