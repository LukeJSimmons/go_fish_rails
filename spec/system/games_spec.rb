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
end
