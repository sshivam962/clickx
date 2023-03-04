module Internal
  def self.table_name_prefix
    'clickx_'
  end
end

# Task to seed current packages into clickx packages
# ActiveRecord::Base.transaction do
#   Package.find_each do |package|
#     cpackage =
#       Internal::Package.create(
#         package.slice(:name, :key, :sales_pitch, :sales_pitch_enabled)
#       )
#     package.plans.each do |plan|
#       cpackage.plans.create(
#         plan.slice(
#           :name, :key, :product_name, :amount, :billing_category,
#           :interval, :stripe_plan, :package_name, :package_type,
#           :implementation_fee, :display_tag
#         )
#       )
#     end
#   end
# end
