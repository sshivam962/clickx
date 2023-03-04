class AddDraftToFunnelPages < ActiveRecord::Migration[5.1]
  def change
    add_column :funnel_pages, :draft, :boolean, default: true
  end
end
