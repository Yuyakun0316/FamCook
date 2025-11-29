class CreateFamilies < ActiveRecord::Migration[7.0]
  def change
    create_table :families do |t|
      t.string :name                               # 任意（例：山田家）
      t.string :code, null: false, index: { unique: true }  # 招待コード（重複不可）

      t.timestamps
    end
  end
end
