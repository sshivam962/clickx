class AddTimezoneToBusinesses < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :timezone, :string, default: 'Central Time (US & Canada)'
  end
end
