class AddCnameToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :cname, :string, default: ''
  end
end
