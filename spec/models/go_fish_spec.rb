require_relative '../../app/models/go_fish'
require_relative '../../app/models/player'

RSpec.describe GoFish do
  let(:player1) { Player.new(0, 'Player 1') }
  let(:player2) { Player.new(1, 'Player 2') }
  let(:go_fish) { GoFish.new([ player1, player2 ]) }
  it 'has a deck' do
    expect(go_fish).to respond_to :deck
    expect(go_fish.deck).to be_a Deck
  end

  it 'has players' do
    expect(go_fish).to respond_to :players
  end

  it 'has a round' do
    expect(go_fish).to respond_to :round
  end

  describe '#current_player' do
    context 'on round 1' do
      it 'returns player at current_player_index' do
        expect(go_fish.current_player).to eq go_fish.players.first
      end
    end

    context 'on round 2' do
      before do
        go_fish.advance_round
      end

      it 'returns player at current_player_index' do
        expect(go_fish.current_player).to eq go_fish.players[1]
      end
    end
  end
end
