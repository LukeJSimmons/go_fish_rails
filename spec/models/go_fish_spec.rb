RSpec.describe GoFish do
  let(:deck) { Deck.new }
  let(:player1_hand) { [] }
  let(:player2_hand) { [] }
  let(:player1) { Player.new(0, 'Player 1', player1_hand) }
  let(:player2) { Player.new(1, 'Player 2', player2_hand) }
  let(:go_fish) { GoFish.new([ player1, player2 ], deck) }
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

  describe '#play_round!' do
    let(:player1_hand) { [ Card.new('A', 'H') ] }
    let(:player2_hand) { [ Card.new('A', 'D') ] }
    let(:target) { go_fish.opponents.first.name }
    let(:request) { go_fish.current_player.hand.first.rank }

    it 'adds round result to round results' do
      expect {
        go_fish.play_round!(target, request)
      }.to change(go_fish.round_results, :count).by 1
    end

    context 'when target has request' do
      before do
        go_fish.play_round!(target, request)
      end

      it 'has proper matching cards' do
        expect(go_fish.round_results.last.matching_cards).to eq player2_hand
      end

      it 'removes matching cards from target hand' do
        go_fish.round_results.last.matching_cards.each do |card|
          expect(go_fish.round_results.last.target.hand).to_not include card
        end
      end

      it 'adds matching cards to current_player hand' do
        go_fish.round_results.last.matching_cards.each do |card|
          expect(go_fish.round_results.last.current_player.hand).to include card
        end
      end

      it 'does not switch turns' do
        expect(go_fish.current_player).to eq go_fish.round_results.last.current_player
      end
    end

    context 'when target does not have request' do
      let(:second_request) { "A" }
      before do
        go_fish.play_round!(target, request)
        go_fish.play_round!(target, second_request)
      end

      it 'draws a card' do
        expect(go_fish.round_results.last.drawn_card).to respond_to :rank
      end

      it 'adds drawn card to current player hand' do
        expect(go_fish.round_results.last.current_player.hand).to include go_fish.round_results.last.drawn_card
      end

      context 'when drawn card is request' do
        let(:second_request) { "K" }

        it 'does not switch turns' do
          expect(go_fish.current_player).to eq go_fish.round_results.last.current_player
        end
      end

      context 'when drawn card is not request' do
        it 'switches turns' do
          expect(go_fish.current_player).to_not eq go_fish.round_results.last.current_player
        end
      end

      context 'when deck is empty' do
        let(:deck) { Deck.new([]) }

        it 'does not draw card' do
          expect(go_fish.round_results.last.drawn_card).to eq nil
        end
      end
    end
  end
end
