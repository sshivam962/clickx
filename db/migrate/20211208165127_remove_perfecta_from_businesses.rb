class RemovePerfectaFromBusinesses < ActiveRecord::Migration[5.1]
  def change
    remove_column :businesses, :perfecta_service, :boolean, default: false
    remove_column :businesses, :perfecta_site_id, :string
    remove_column :businesses, :perfecta_cost_markup, :float, default: 0.0
    remove_column :businesses, :perfecta_username, :string
    remove_column :businesses, :perfecta_password, :string
    remove_column :intelligence_caches, :last_30_days_perfecta_reports, :jsonb
  end
end
