class AddOwnerIdToFamilies < ActiveRecord::Migration[7.1]
  def change
    unless column_exists?(:families, :owner_id)
      add_reference :families, :owner,
                    foreign_key: { to_table: :users },
                    null: true
    end
  end
end
