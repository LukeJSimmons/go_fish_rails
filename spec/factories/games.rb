FactoryBot.define do
  factory :game do
    game_user
    name { "MyString" }
    players_count { 1 }
  end
end
