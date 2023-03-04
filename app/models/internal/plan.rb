class Internal::Plan < ApplicationRecord
  belongs_to :package,
             class_name: 'Internal::Package',
             foreign_key: :clickx_package_id

  validates :key, uniqueness: { scope: :clickx_package_id }

  enum billing_category: %i[subscription charge]

  def custom?
    package_type.eql?('custom')
  end

  def title
    { starter: 'Start', pro: 'Grow', advanced: 'Scale'}[key.to_sym] ||
    key.titleize
  end
end
