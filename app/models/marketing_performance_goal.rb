# frozen_string_literal: true

class MarketingPerformanceGoal < ApplicationRecord
  belongs_to :business
  validates :business_id, presence: { on: :create, message: "can't be blank" }
end
