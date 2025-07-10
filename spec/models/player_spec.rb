RSpec.describe Player do
  let(:player) { Player.new(1, 'Player 1') }
  it 'has a user_id' do
    expect(player).to respond_to :user_id
  end

  it 'has a name' do
    expect(player).to respond_to :name
  end

  describe '#add_card_to_hand' do
    it 'only adds Card objects' do
      expect {
        player.add_card_to_hand(nil)
    }.to_not change(player.hand, :count)
    end
  end

  describe '#score_books_if_possible' do
    let(:book) { [ Card.new('A', 'H'), Card.new('A', 'D'), Card.new('A', 'S'), Card.new('A', 'C') ] }
    it 'returns scored books' do
      player.hand.push(*book)
      expect(player.score_books_if_possible!).to eq [ book ]
    end
  end
end
