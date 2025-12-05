FactoryBot.define do
  factory :family do
    name { "テスト家族" }
    code { SecureRandom.hex(4) }  # 自動生成
  end
end