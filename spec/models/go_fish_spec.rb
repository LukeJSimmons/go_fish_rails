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

  describe '#opponents' do
    it 'returns opponents' do
      expect(go_fish.opponents).to_not include go_fish.current_player
      expect(go_fish.opponents.all? { |opponent| go_fish.players.include? opponent }).to eq true
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
        let(:deck) { Deck.new([ Card.new('K', 'S') ]) }
        let(:second_request) { "K" }

        it 'does not switch turns' do
          expect(go_fish.current_player).to eq go_fish.round_results.last.current_player
        end
      end

      context 'when drawn card is not request' do
        let(:deck) { Deck.new([ Card.new('9', 'H') ]) }

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

    context 'when player makes a book' do
      let(:player1_hand) { [ Card.new('A', 'H'), Card.new('A', 'D'), Card.new('A', 'S') ] }
      let(:player2_hand) { [ Card.new('A', 'C') ] }

      it 'removes book from hand' do
        go_fish.play_round!(target, request)
        expect(go_fish.round_results.last.current_player.hand.count).to eq 0
      end

      it 'adds book to books' do
        go_fish.play_round!(target, request)
        expect(go_fish.round_results.last.current_player.books.count).to eq 1
      end
    end
  end

  describe '#winner' do
    context 'when Player 1 has the most books' do
      before do
        player1.books = [ [ Card.new('A', 'H') ] ]
      end

      it 'returns Player 1' do
        expect(go_fish.winner).to eq player1
      end
    end

    context 'when Player 2 has the most books' do
      before do
        player2.books = [ [ Card.new('A', 'H') ] ]
      end

      it 'returns Player 2' do
        expect(go_fish.winner).to eq player2
      end
    end

    context 'when Players are tied for the most books' do
      context 'when Player 1 has highest rank book' do
        before do
          player1.books = [ [ Card.new('A', 'H') ], [ Card.new('J', 'H') ] ]
          player2.books = [ [ Card.new('Q', 'H') ], [ Card.new('K', 'H') ] ]
        end
        it 'returns Player 1' do
          expect(go_fish.winner).to eq player1
        end
      end

      context 'when Player 2 has highest rank book' do
        before do
          player1.books = [ [ Card.new('Q', 'H') ] ]
          player2.books = [ [ Card.new('A', 'H') ] ]
        end
        it 'returns Player 2' do
          expect(go_fish.winner).to eq player2
        end
      end
    end
  end

  describe '#game_over?' do
    context 'when the deck is not empty' do
      it 'returns false' do
        expect(go_fish.game_over?).to eq false
      end
    end

    context 'when the deck is empty but hands are not' do
      let(:deck) { Deck.new([]) }
      let(:player1_hand) { [ Card.new('A', 'H') ] }

      it 'returns false' do
        expect(go_fish.game_over?).to eq false
      end
    end

    context 'when the deck and all hands are empty' do
      let(:deck) { Deck.new([]) }

      it 'returns true' do
        expect(go_fish.game_over?).to eq true
      end
    end
  end
end
