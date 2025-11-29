class AddFamilyIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :family_id, :integer
    add_index  :users, :family_id
  end
end