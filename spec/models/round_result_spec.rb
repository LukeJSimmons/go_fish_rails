RSpec.describe RoundResult do
  let(:current_player) { Player.new('Player 1', 0) }
  let(:target) { Player.new('Player 2', 1) }
  let(:request) { "A" }
  let(:matching_cards) { [] }
  let(:fished_card) { nil }
  let(:scored_books) { [] }
  let(:drawn_cards) { [] }
  let(:result) { RoundResult.new(current_player:, target:, request:, matching_cards:, fished_card:, scored_books:, drawn_cards:) }

  describe '#player_action' do
    it 'displays target and request' do
      expect(result.player_action(current_player)).to include target.name
      expect(result.player_action(current_player)).to include request
    end

    context 'when displaying to current_player' do
      it 'displays message in the 2nd person' do
        expect(result.player_action(current_player)).to include "You"
      end
    end

    context 'when displaying to opponent' do
      it 'displays message in the 3rd person' do
        expect(result.player_action(nil)).to include current_player.name
      end
    end

    context 'when displaying to target' do
      it 'displays message in the 2nd person' do
        expect(result.player_action(target)).to include "asked You"
      end
    end
  end

  describe '#player_response' do
    context 'when target has request' do
      let(:matching_cards) { [ Card.new('A', 'D') ] }

      it 'displays correct message' do
        expect(result.player_response(current_player)).to include "took"
        expect(result.player_response(current_player)).to include "#{matching_cards.count}"
        expect(result.player_response(current_player)).to include target.name
        expect(result.player_response(current_player)).to include request
      end

      context 'when displaying to target' do
        it 'displays message in the 2nd person' do
          expect(result.player_response(target)).to include "from You"
        end
      end
    end

    context 'when target does not have request' do
      it 'displays correct message' do
        expect(result.player_response(current_player)).to include "didn't have any"
      end

      context 'when displaying to target' do
        it 'displays message in the 2nd person' do
          expect(result.player_response(target)).to include "You didn't"
        end
      end
    end
  end

  describe '#game_response' do
    context 'when target has request' do
      let(:matching_cards) { [ Card.new('A', 'H') ] }

      it 'returns nil' do
        expect(result.game_response(current_player)).to eq nil
      end
    end

    context 'when target does not have request' do
      let(:fished_card) { Card.new('8', 'H') }

      context 'when displaying to current_player' do
        it 'displays drawn card' do
          expect(result.game_response(current_player)).to include result.fished_card.rank
        end
      end

      context 'when displaying to opponents' do
        it 'does not display drawn card' do
            expect(result.game_response(target)).to_not include result.fished_card.rank
        end
      end

      context 'when the deck is empty' do
        let(:fished_card) { nil }

        it 'displays empty deck message' do
          expect(result.game_response(current_player)).to include "deck is empty"
        end
      end
    end
  end

  describe '#draw_card_message' do
    let(:fished_card) { Card.new('8', 'H') }

    context 'when displaying to current_player' do
      it 'displays card rank' do
        expect(result.draw_card_message(current_player, fished_card)).to include fished_card.rank
      end

      it 'displays in the 2nd person' do
        expect(result.draw_card_message(current_player, fished_card)).to include "You"
      end
    end

    context 'when displaying to opponent' do
      it 'displays only that the player drew a card' do
        expect(result.draw_card_message(target, fished_card)).to_not include fished_card.rank
        expect(result.draw_card_message(target, fished_card)).to include "drew"
      end

      it 'displays in the 3rd person' do
        expect(result.draw_card_message(target, fished_card)).to include current_player.name
      end
    end
  end

  describe '#book_message' do
    let(:scored_books) { [ [ Card.new('A', 'H'), Card.new('A', 'D'), Card.new('A', 'S'), Card.new('A', 'C') ] ] }

    it 'displays scored_books' do
      expect(result.book_message(current_player, scored_books.first)).to include "book of #{scored_books.first.first.rank}"
    end

    context 'when displaying to current_player' do
      it 'displays message in the 2nd person' do
        expect(result.book_message(current_player, scored_books.first)).to include "You"
      end
    end

    context 'when displaying to opponent' do
      it 'displays message in the 3rd person' do
        expect(result.book_message(target, scored_books.first)).to include current_player.name
      end
    end
  end
end
