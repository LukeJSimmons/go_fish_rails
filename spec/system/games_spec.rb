require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'games', type: :system, js: true do
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
    let(:name) { 'Game' }
    let(:players_count) { 2 }

    before do
      create_game(name, players_count)
    end

    it 'shows the game page' do
      click_on "Play", match: :first
      expect(page).to have_content("Game")
      expect(page).to have_content("1/2")
      expect(page).to have_content(user.email)
    end

    context 'when you are not in the game' do
      let!(:other_user) { create(:user) }

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
    let(:name) { 'Game' }
    let(:players_count) { 2 }

    before do
      login_as user
      visit games_path
      create_game(name, players_count)
      login_as other_user
      visit games_path
      click_on 'Join'
    end

    it 'displays players' do
      expect(page).to have_content(user.email)
      expect(page).to have_content(other_user.email)
    end

    it 'displays hand' do
      expect(page).to have_content(Game.all.first.get_player_by_user(user)&.hand)
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
