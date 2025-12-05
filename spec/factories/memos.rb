FactoryBot.define do
  factory :memo do
    association :user
    association :family
    content { '牛乳を買う' }
    pinned { false }
  end
end
