class AddPinnedToMemos < ActiveRecord::Migration[7.1]
  def change
    add_column :memos, :pinned, :boolean, default: false, null: false
  end
end
