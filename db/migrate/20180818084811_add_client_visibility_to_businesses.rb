class AddClientVisibilityToBusinesses < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :client_visibility,  :boolean, default: false
  end
end
