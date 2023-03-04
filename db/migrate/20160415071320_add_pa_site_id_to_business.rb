class AddPaSiteIdToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :perfecta_service, :boolean, default: false
    add_column :businesses, :perfecta_site_id, :string
  end
end
