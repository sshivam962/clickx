class StrategyImage < ApplicationRecord
  belongs_to :lead_strategy, class_name: 'Lead::Strategy'

  mount_uploader :file, ImageUploader

  scope :order_by_created, -> { order(created_at: :asc) }
end
