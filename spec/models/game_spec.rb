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

    it 'increments total_games' do
      game.start_if_possible!
      expect(User.find(user.id).total_games).to eq 1
      expect(User.find(other_user.id).total_games).to eq 1
    end
  end

  describe '#winner' do
    before do
      game.start_if_possible!
      allow(game.go_fish).to receive(:winner).and_return(game.get_player_by_user(user))
    end

    it 'increments total_wins for winner' do
      game.winner
      expect(User.find(other_user.id).total_wins).to eq 0
      expect(User.find(user.id).total_wins).to eq 1
    end
  end
end
