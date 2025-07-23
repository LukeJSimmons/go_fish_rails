require 'rails_helper'

RSpec.describe Game, type: :model do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:game) { create(:game, users: [ user, other_user ]) }

  describe '#start_if_possible!' do
    it 'sets go_fish to GoFish game' do
      game.start_if_possible!
      expect(game.go_fish).to respond_to :deck
    end

    it 'sets up go_fish with a player for each user' do
      game.start_if_possible!
      expect(game.go_fish.players.count).to eq game.users.count
      expect(game.go_fish.players.all? { |player| player.respond_to? :user_id }).to eq true
    end

    it 'deals hands to players' do
      game.start_if_possible!
      expect(game.go_fish.deck.cards_left).to eq Deck::BASE_DECK_SIZE - (GoFish::BASE_HAND_SIZE * 2)
      expect(game.go_fish.players.first.hand.count).to eq 7
    end

    it 'sets end_time to current time' do
      game.start_if_possible!
      expect(game.start_time.utc).to be_within(1.second).of Time.now
    end
  end

  describe '#winner' do
    before do
      game.start_if_possible!
    end

    context 'when game is not over' do
      it 'returns nil' do
        expect(game.winner).to eq nil
      end
    end

    context 'when game is over' do
      before do
        allow(game).to receive(:game_over?).and_return(true)
      end

      it 'sets winner_id to winner user_id' do
        winner = game.winner
        expect(game.winner_id).to eq winner.user_id
      end

      it 'sets end_time to current time' do
        game.winner
        expect(game.end_time.utc).to be_within(1.second).of Time.now
      end
    end
  end
end
