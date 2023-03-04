class FbAdReport < ApplicationRecord
  belongs_to :business

  validates :report_date, presence: true, uniqueness: { scope: :business_id }
end



