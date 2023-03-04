class RemoveAgencyIdFromFunnelPages < ActiveRecord::Migration[5.1]
  def change
    remove_column :funnel_pages, :agency_id
  end
end
