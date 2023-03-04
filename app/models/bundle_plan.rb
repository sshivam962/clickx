class BundlePlan < ApplicationRecord
  belongs_to :bundle_package

  validates :key, uniqueness: { scope: :bundle_package_id }

  enum billing_category: %i[subscription charge]

  def interval_text
    case interval
    when 'month'
      '/mo'
    when 'year'
      '/yr'
    else
      " #{interval}"
    end
  end

  def custom?
    package_type.eql?('custom')
  end
end
