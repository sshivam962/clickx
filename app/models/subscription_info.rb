# frozen_string_literal: true

class SubscriptionInfo < ApplicationRecord
  self.table_name = 'subscriptions'
  belongs_to :business, required: true
end
