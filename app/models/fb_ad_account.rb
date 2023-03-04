# frozen_string_literal: true

class FbAdAccount < ApplicationRecord
  belongs_to :business

  validates :business_id, uniqueness: true

  delegate :fb_ad_cost_markup, to: :business, allow_nil: true
end
