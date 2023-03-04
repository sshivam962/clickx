class AddNutshellServiceToBusiness < ActiveRecord::Migration[5.1]
  def up
    add_column :businesses, :nutshell_service, :boolean, default: false
  end

  def down
    remove_column :businesses, :nutshell_service
  end
end
