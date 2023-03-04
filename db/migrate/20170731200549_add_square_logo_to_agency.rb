class AddSquareLogoToAgency < ActiveRecord::Migration[4.2]
  def change
    add_column :agencies, :square_logo, :string
  end
end
