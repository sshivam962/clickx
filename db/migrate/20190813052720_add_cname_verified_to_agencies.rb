class AddCnameVerifiedToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :cname_verified, :boolean, default: false
  end
end
