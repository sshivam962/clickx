# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :order_by_created, -> { order(created_at: :asc) }
end
