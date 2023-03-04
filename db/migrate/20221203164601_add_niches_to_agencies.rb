class AddNichesToAgencies < ActiveRecord::Migration[5.2]
  def change
    add_column :agencies, :niches, :string
  end
end
