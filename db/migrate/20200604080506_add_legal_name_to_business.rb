class AddLegalNameToBusiness < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :legal_name, :string
  end
end
