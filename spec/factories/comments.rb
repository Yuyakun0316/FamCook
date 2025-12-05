FactoryBot.define do
  factory :comment do
    association :user
    association :meal
    rating { 3 }
    content { 'おいしかった！' }
  end
end
