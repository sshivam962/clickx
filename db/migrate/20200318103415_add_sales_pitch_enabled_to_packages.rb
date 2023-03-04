class AddSalesPitchEnabledToPackages < ActiveRecord::Migration[5.1]
  def up
    add_column :packages, :sales_pitch_enabled, :boolean, default: false

    Package.where.not(
      key: ['agency_infrastructure', 'ala_carte']
    ).update_all(sales_pitch_enabled: true)
  end

  def down
    remove_column :packages, :sales_pitch_enabled
  end
end
