class AddNewServicesToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :social_magnet_service, :boolean, default: true
    add_column :businesses, :social_publishing_service, :boolean, default: true
  end
end
