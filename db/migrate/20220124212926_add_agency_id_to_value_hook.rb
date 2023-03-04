class AddAgencyIdToValueHook < ActiveRecord::Migration[5.1]
  def change
    add_column :value_hooks, :agency_id, :integer, index: true
  end
end
