class AddLogoToBusinesses < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :logo, :string
  end
end
