class AddLeadFormRequiredToFunnelPages < ActiveRecord::Migration[5.1]
  def change
    add_column :funnel_pages, :lead_form_required, :boolean
  end
end
