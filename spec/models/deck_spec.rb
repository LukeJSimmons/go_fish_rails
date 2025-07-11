RSpec.describe Deck do
  let(:deck) { Deck.new }

  it 'has cards' do
    expect(deck).to respond_to :cards
    expect(deck.cards.count).to eq Deck::BASE_DECK_SIZE
    expect(deck.cards.all? { |card| card.respond_to? :rank }).to eq true
  end

  it 'has four cards for each rank' do
    Card::RANKS.each do |rank|
      expect(deck.cards.select { |card| card.rank == rank }.count).to eq 4
    end
  end

  describe '#cards_left' do
    it 'returns card count' do
      expect(deck.cards_left).to eq deck.cards.count
    end
  end

  describe '#shuffle!' do
    it 'shuffles the deck' do
      expect(deck).to eq Deck.new
      deck.shuffle!
      expect(deck).to_not eq Deck.new
    end
  end

  describe '#empty?' do
    context 'when cards_left is 0' do
      let(:deck) { Deck.new([]) }
      it 'returns true' do
        expect(deck.empty?).to eq true
      end
    end

    context 'when cards_left is greater than 0' do
      it 'returns false' do
        expect(deck.empty?).to eq false
      end
    end
  end
end
