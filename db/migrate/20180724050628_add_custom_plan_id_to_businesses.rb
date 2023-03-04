class AddCustomPlanIdToBusinesses < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :custom_plan_id, :integer
  end
end
