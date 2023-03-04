class AddMandatoryToAddonPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :addon_plans, :mandatory, :boolean, default: false
  end
end
