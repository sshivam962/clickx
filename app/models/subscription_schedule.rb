# frozen_string_literal: true
class SubscriptionSchedule < ApplicationRecord
  belongs_to :agency
  enum status: %i[not_started active completed released canceled]
end
