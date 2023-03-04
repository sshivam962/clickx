class AddBillingCategoryToCustomPackages < ActiveRecord::Migration[5.1]
  def change
    add_column :custom_packages, :billing_category, :integer
  end
end
