class AddConvertedToDirectLeads < ActiveRecord::Migration[5.2]
  def change
    add_column :direct_leads, :converted, :boolean, default: false
  end
end
