class ChangeOwnerIdNullableInFamilies < ActiveRecord::Migration[7.1]
  def change
    change_column_null :families, :owner_id, true
  end
end