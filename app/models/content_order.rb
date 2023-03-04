# frozen_string_literal: true

class ContentOrder < ApplicationRecord
  belongs_to :business
  belongs_to :user

  enum order_status: %i[draft ordered waiting_for_content complete]
  enum payment_status: %i[incomplete completed]

  def days
    (1..20).map do |i|
      "#{ i+1 } days"
    end
  end

end
