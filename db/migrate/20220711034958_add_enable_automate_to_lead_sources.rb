class AddEnableAutomateToLeadSources < ActiveRecord::Migration[5.2]
  def change
    add_column :lead_sources, :enable_automate, :boolean, default: false
  end
end