# 1. 家族を固定のコードで作成
family = Family.find_or_create_by!(code: '8c89b74e') do |f|
  f.name = "テスト家族"
end

# 2. テストユーザー（README記載のログイン用）を作成
test_user = User.find_or_create_by!(email: 'test@gmail.com') do |u|
  u.name = "テストユーザー"
  u.password = "Test1234"
  u.family_id = family.id
end

# 家族の管理者をテストユーザーに設定（管理者権限を付与するため）
family.update!(owner_id: test_user.id)

# 3. ゲストユーザー（ボタン用）を作成
guest_user = User.find_or_create_by!(email: 'guest@example.com') do |u|
  u.name = "ゲスト（閲覧用）"
  u.password = "password"
  u.family_id = family.id
end

# 4. サンプル献立を作成
puts "Creating sample meals..."
meals_data = [
  { title: "手作りハンバーグ", date: Date.today, meal_type: 2, icon_type: 1 },
  { title: "朝のフレンチトースト", date: Date.today, meal_type: 0, icon_type: 2 },
  { title: "具沢山カレー", date: Date.yesterday, meal_type: 2, icon_type: 3 },
  { title: "冷やし中華", date: Date.today.prev_month, meal_type: 1, icon_type: 4 }
]

meals_data.each do |data|
  Meal.find_or_create_by!(
    title: data[:title],
    user_id: guest_user.id, # ゲストユーザーの投稿として作成
    family_id: family.id,
    date: data[:date]
  ) do |m|
    m.meal_type = data[:meal_type]
    m.icon_type = data[:icon_type]
    m.description = "これは自動生成されたサンプル献立です。"
  end
end

puts "Seed completed!"