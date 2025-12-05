FactoryBot.define do
  factory :meal do
    association :user
    association :family
    title { 'カレーライス' }
    description { 'おいしくできました！' }
    date { Date.today }
    meal_type { :dinner }
    icon_type { :curry }

    # ActiveStorage 用：画像を添付できるメソッド
    after(:build) do |meal|
      meal.images.attach(
        io: File.open(Rails.root.join('spec/fixtures/files/sample.jpg')),
        filename: 'sample.jpg',
        content_type: 'image/jpeg'
      )
    end
  end
end
