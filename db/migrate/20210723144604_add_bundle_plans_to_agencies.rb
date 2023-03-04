class AddBundlePlansToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :bundle_plans, :boolean, default: false
  end
end
