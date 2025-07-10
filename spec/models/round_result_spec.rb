RSpec.describe RoundResult do
  let(:current_player) { Player.new(0, 'Player 1') }
  let(:target) { Player.new(1, 'Player 2') }
  let(:request) { "A" }
  let(:matching_cards) { [] }
  let(:result) { RoundResult.new(current_player:, target:, request:, matching_cards:) }

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
        expect(result.player_action(target)).to include current_player.name
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
    end

    context 'when target does not have request' do
      it 'displays correct message' do
        expect(result.player_response(current_player)).to include "didn't have any"
      end
    end
  end
end
