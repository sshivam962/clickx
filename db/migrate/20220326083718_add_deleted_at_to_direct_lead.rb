class AddDeletedAtToDirectLead < ActiveRecord::Migration[5.1]
  def change
    add_column :direct_leads, :deleted_at, :datetime
    add_index :direct_leads, :deleted_at
  end
end
