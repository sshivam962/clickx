class AddLegalNameToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :legal_name, :string
  end
end
