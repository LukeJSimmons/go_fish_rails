require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'games', type: :system, js: true do
  let!(:user) { create(:user) }

  before do
    sign_in user

    visit games_path
  end

  describe 'creating a new game' do
    it 'has a new game button' do
      expect(page).to have_content("New game")
    end

    it 'creates a game' do
      click_on "New game"
      expect(page).to have_content("New game")
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
      click_on "Play"
      expect(page).to have_content("Game")
      expect(page).to have_content("1/2")
      expect(page).to have_content("Back to games")
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
