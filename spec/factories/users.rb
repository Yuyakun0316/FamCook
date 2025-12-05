FactoryBot.define do
  factory :user do
    name { "テスト太郎" }
    email { Faker::Internet.email }
    password { "password" }
    association :family
  end
end