class AddColumnManagedServicesToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :managed_seo_service, :boolean, default: false
    add_column :businesses, :managed_ppc_service, :boolean, default: false
  end
end
