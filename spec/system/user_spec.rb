require 'rails_helper'
include Warden::Test::Helpers

RSpec.describe 'users', type: :system do
  let!(:user) { create(:user) }

  context 'when user is not signed in' do
    before do
      visit '/'
    end

    it 'shows the login page' do
      expect(page).to have_content("Log in")
    end
  end

  context 'when user is signed in' do
    before do
      visit '/'
      sign_in user
      visit '/'
    end

    it 'shows the games page' do
      expect(page).to have_content("Games")
    end
  end
end
