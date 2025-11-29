class AddFamilyIdToMemos < ActiveRecord::Migration[7.0]
  def change
    add_column :memos, :family_id, :integer
    add_index  :memos, :family_id
  end
end
