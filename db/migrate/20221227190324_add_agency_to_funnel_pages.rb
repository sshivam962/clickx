class AddAgencyToFunnelPages < ActiveRecord::Migration[5.2]
  def change
  	add_reference :funnel_pages, :agency, index: true, default:nil
  	add_reference :funnel_pages, :funnel_page, index: true, default:nil
  end
end
