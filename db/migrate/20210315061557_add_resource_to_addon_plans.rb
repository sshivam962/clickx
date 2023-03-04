class AddResourceToAddonPlans < ActiveRecord::Migration[5.1]
  def up
    add_column :addon_plans, :resource_id, :bigint
    add_column :addon_plans, :resource_type, :string
    AddonPlan.find_each do |plan|
      plan.update(resource_id: plan.package_id, resource_type: 'Package')
    end
  end

  def down
    AddonPlan.where(resource_type: 'Package').find_each do |plan|
      plan.update(package_id: plan.resource_id)
    end
    remove_column :addon_plans, :resource_id, :bigint
    remove_column :addon_plans, :resource_type, :string
  end
end
