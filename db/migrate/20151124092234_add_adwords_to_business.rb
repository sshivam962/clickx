class AddAdwordsToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :adword_service, :boolean
    add_column :businesses, :adword_client_id, :string
  end
end
