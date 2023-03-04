class AddCloseioServiceToBusiness < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :closeio_service, :boolean, default: false
  end
end
