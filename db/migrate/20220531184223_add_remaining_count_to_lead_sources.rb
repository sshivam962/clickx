class AddRemainingCountToLeadSources < ActiveRecord::Migration[5.2]
  def change
    add_column :lead_sources, :remaining_count, :integer, default: 0
  end
end
