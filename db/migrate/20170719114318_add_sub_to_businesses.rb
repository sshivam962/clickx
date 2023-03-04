class AddSubToBusinesses < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :sub, :string
  end
end
