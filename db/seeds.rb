# 1. ゲスト用の家族を作成（または取得）
family = Family.find_or_create_by!(code: '8c89b74e') do |f|
  f.name = "テスト家族"
  # owner_idは最初のユーザー作成後に紐付けるか、一旦nilでもOKな設計ならそのままで
end

# 2. ゲストユーザーを作成
guest_user = User.find_or_create_by!(email: 'guest@example.com') do |u|
  u.name = "ゲスト（閲覧用）"
  u.password = "password" # 固定でOK
  u.family_id = family.id
end

# 3. サンプル献立をいくつか作成
# ゲストログインした時にカレンダーが埋まるように、今日の日付付近で作成します
puts "Creating sample meals..."
[
  { title: "手作りハンバーグ", date: Date.today, meal_type: 2, icon_type: 1 },
  { title: "朝のフレンチトースト", date: Date.today, meal_type: 0, icon_type: 2 },
  { title: "具沢山カレー", date: Date.yesterday, meal_type: 2, icon_type: 3 },
  { title: "冷やし中華", date: Date.today.prev_month, meal_type: 1, icon_type: 4 }
].each do |meal_attributes|
  Meal.find_or_create_by!(
    title: meal_attributes[:title],
    user_id: guest_user.id,
    family_id: family.id,
    date: meal_attributes[:date]
  ) do |m|
    m.meal_type = meal_attributes[:meal_type]
    m.icon_type = meal_attributes[:icon_type]
    m.description = "これは自動生成されたサンプル献立です。"
  end
end

puts "Seed completed!"