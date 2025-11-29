class AddFamilyIdToMeals < ActiveRecord::Migration[7.0]
  def change
    add_column :meals, :family_id, :integer
    add_index  :meals, :family_id
  end
end