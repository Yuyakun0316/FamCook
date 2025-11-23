class CreateMeals < ActiveRecord::Migration[7.1]
  def change
    create_table :meals do |t|
      t.string :title                # 料理名
      t.text :description            # コメント
      t.date :date                   # 日付
      t.references :user, null: false, foreign_key: true  # 投稿したユーザー
      t.integer :meal_type, default: 2  # ★ 追加 → デフォルトは夕食（2）

      t.timestamps
    end
  end
end
