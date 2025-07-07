FactoryBot.define do
  factory :user do
    email { |n| "test#{n}@example.com" }
    password { "password" }
  end
end
