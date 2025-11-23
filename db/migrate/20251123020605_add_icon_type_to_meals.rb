class AddIconTypeToMeals < ActiveRecord::Migration[7.1]
  def change
    add_column :meals, :icon_type, :integer
  end
end
