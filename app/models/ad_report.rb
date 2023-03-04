# frozen_string_literal: true

class AdReport < ApplicationRecord
  belongs_to :business

  include CommonReportScopes
end
