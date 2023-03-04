class AddHomeLinksToAgenciesAndBusinesses < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :home_link, :string
    add_column :businesses, :home_link, :string
  end
end
