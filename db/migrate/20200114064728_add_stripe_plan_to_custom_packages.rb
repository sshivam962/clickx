class AddStripePlanToCustomPackages < ActiveRecord::Migration[5.1]
  def change
    add_column :custom_packages, :stripe_plan, :string
  end
end
