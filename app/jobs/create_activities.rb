# frozen_string_literal: true

class CreateActivities < ApplicationJob
  def perform(attributes_changed, user_id, business_id)
    ActiveRecord::Base.connection_pool.with_connection do
      if business_id.present?
        Activity.create(
          user_id: user_id,
          business_id: business_id,
          revisions: attributes_changed
        )
      end
    end
  end
end
