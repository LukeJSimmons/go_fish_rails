RSpec.describe Deck do
  let(:deck) { Deck.new }

  it 'has cards' do
    expect(deck).to respond_to :cards
    expect(deck.cards.count).to eq Deck::BASE_DECK_SIZE
    expect(deck.cards.all? { |card| card.respond_to? :rank }).to eq true
  end

  describe '#cards_left' do
    it 'returns card count' do
      expect(deck.cards_left).to eq deck.cards.count
    end
  end
end
