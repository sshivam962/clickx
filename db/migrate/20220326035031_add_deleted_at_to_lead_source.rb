class AddDeletedAtToLeadSource < ActiveRecord::Migration[5.1]
  def change
    add_column :lead_sources, :deleted_at, :datetime
    add_index :lead_sources, :deleted_at
  end
end
