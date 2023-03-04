class AddValueHookToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :value_hook, :boolean, default: false
  end
end
