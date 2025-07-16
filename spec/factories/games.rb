FactoryBot.define do
  factory :game do
    name { "MyString" }
    players_count { 2 }
    bots_count { 0 }
  end
end
