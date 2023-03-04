class AddEnabledPackagesToAgencies < ActiveRecord::Migration[5.1]
  def up
    add_column :agencies, :enabled_packages, :text, array: true

    Agency.update_all(
      enabled_packages: Package::CLIENT_PACKAGES - %w[social_media digital_pr]
    )
  end

  def down
    remove_column :agencies, :enabled_packages
  end
end
