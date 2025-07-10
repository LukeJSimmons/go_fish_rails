require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'games', type: :system do
  let!(:user) { create(:user) }

  before do
    login_as user
    visit games_path
  end

  describe 'creating a new game' do
    it 'has a new game button' do
      expect(page).to have_content("New game")
    end

    it 'creates a game' do
      click_on "New game"
      fill_in "Name", with: "Gamey game"
      fill_in "Players count", with: 2
      click_on "Create game"
      expect(page).to have_content("Gamey game")
    end
  end

  describe 'showing a game' do
    let!(:game) { create(:game, users: [ user ]) }

    it 'shows the game page' do
      visit games_path
      click_on "Play", match: :first
      expect(page).to have_content("Waiting for players...")
    end

    context 'when you are not in the game' do
      let!(:other_user) { create(:user) }
      let!(:game) { create(:game, users: [ user ]) }

      before do
        login_as other_user
        visit games_path
      end

      it 'increments players on join' do
        expect(page).to have_content("Join")
        click_on "Join", match: :first
        expect(page).to have_content("2/2")
      end
    end
  end

  describe 'editing a game' do
    let(:name) { 'Game' }
    let(:players_count) { 2 }

    before do
      create_game(name, players_count)
    end

    it 'has an edit game button' do
      expect(page).to have_content("Edit")
    end

    it 'edits the game' do
      click_on "Edit", match: :first
      fill_in "Name", with: "Edited Game"
      click_on "Update game"
      expect(page).to have_content("Edited Game")
    end
  end

  describe 'deleting a game' do
    let(:name) { 'Unique Game Name' }
    let(:players_count) { 2 }

    before do
      create_game(name, players_count)
    end

    it 'has an delete game button' do
      expect(page).to have_content("Delete")
    end

    it 'deletes the game' do
      expect(page).to have_content(name)
      click_on "Delete", match: :first
      expect(page).to have_no_content(name)
    end
  end

  describe 'game view' do
    let!(:other_user) { create(:user) }
    let!(:game) { create(:game, users: [ user ]) }

    before do
      login_as other_user
      visit games_path
      expect(page).to have_content("Join")
      click_on "Join"
      expect(page).to have_content("Turn")
      game.reload
    end

    describe 'players section' do
      before do
        game.get_player_by_user(user).books = [ [ Card.new('A', 'H') ] ]
        game.save!
        visit games_path
        click_on "Play"
      end

      it 'displays players books' do
        within '.accordion' do
          expect(page).to have_content(user.email)
          find('span', text: user.email).click
        end
        game.get_player_by_user(user).books.map(&:first).each do |card|
          expect(page).to have_css("img[alt*='#{card.rank}#{card.suit}']")
        end
      end
    end

    describe 'hand' do
      it 'displays hand' do
        game.get_player_by_user(other_user).hand.each do |card|
          expect(page).to have_css("img[alt*='#{card.rank}#{card.suit}']")
        end
      end

      it 'does not display opponent hand' do
        game.get_player_by_user(user).hand.each do |card|
          expect(page).to have_no_css("img[alt*='#{card.rank}#{card.suit}']")
        end
      end
    end

    describe 'books' do
      before do
        game.get_player_by_user(other_user).books = [ [ Card.new('A', 'H') ] ]
        game.save!
        visit games_path
        click_on "Play"
      end

      it 'displays books' do
        game.get_player_by_user(other_user).books.map(&:first).each do |card|
          expect(page).to have_css("img[alt*='#{card.rank}#{card.suit}']")
        end
      end
    end

    describe 'feed' do
      it 'displays current player' do
        expect(page).to have_content("#{game.current_player.name}'s Turn")
      end

      context 'when play round button is pressed' do
        let(:deck) { Deck.new }
        let(:player1_hand) { [ Card.new('A', 'H'), Card.new('A', 'C') ] }
        let(:player2_hand) { [ Card.new('A', 'D'), Card.new('A', 'S') ] }
        let(:target) { other_user.email }
        let(:request) { game.get_player_by_user(user).hand.first.rank }

        before do
          game.go_fish.deck = deck
          game.go_fish.players.first.hand = player1_hand
          game.go_fish.players[1].hand = player2_hand
          game.save!
          login_as user
          visit games_path
          click_on "Play"
        end

        context 'when target has request' do
          before do
            expect(page).to have_button("Play Round")
            select target, from: "Target"
            select request, from: "Request"
            click_on "Play Round"
          end

          it 'displays player action' do
            expect(page).to have_content("You asked #{target} for #{request}s")
          end

          it 'displays player response' do
            expect(page).to have_content("You took 2 #{request}s from #{target}")
          end

          it 'does not display game response' do
            expect(page).to have_no_css(".feed__bubble--game-response")
          end
        end

        context 'when target does not have request' do
          let(:player1_hand) { [ Card.new('10', 'H') ] }
          let(:player2_hand) { [ Card.new('Q', 'D') ] }
          let(:request) { '10' }

          before do
            expect(page).to have_button("Play Round")
            select target, from: "Target"
            select request, from: "Request"
            click_on "Play Round"
          end

          it 'displays game response' do
            expect(page).to have_content("You drew a A")
          end

          context 'when drawn card is not request' do
            it 'changes current_player' do
              expect(page).to have_content("#{game.get_player_by_user(other_user).name}'s Turn")
            end

            it 'disables play round button' do
              expect(page).to have_button("Play Round", disabled: true)
            end
          end
        end
      end
    end
  end

  private

  def create_game(name, players_count)
    click_on "New game"
    fill_in "Name", with: name
    fill_in "Players count", with: players_count
    click_on "Create game"
  end
end
