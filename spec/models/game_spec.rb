require 'rails_helper'

RSpec.describe Game, type: :model do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:game) { create(:game, users: [ user, other_user ]) }

  describe '#start!' do
    it 'sets go_fish to GoFish game' do
      game.start!
      expect(game.go_fish).to respond_to :deck
    end

    it 'sets up go_fish with a player for each user' do
      game.start!
      expect(game.go_fish.players.count).to eq game.users.count
      expect(game.go_fish.players.all? { |player| player.respond_to? :user_id }).to eq true
    end

    it 'deals hands to players' do
      game.start!
      expect(game.go_fish.deck.cards_left).to eq Deck::BASE_DECK_SIZE - (GoFish::BASE_HAND_SIZE * 2)
      expect(game.go_fish.players.first.hand.count).to eq 7
    end
  end
end
