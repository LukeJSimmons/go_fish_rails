FactoryBot.define do
  factory :user do
    username { |n| "Player #{n}" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "password" }
  end
end
