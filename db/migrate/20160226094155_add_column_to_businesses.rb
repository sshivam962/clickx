class AddColumnToBusinesses < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :backlink_service, :boolean, default: false
    add_column :businesses, :domain, :string
  end
end
