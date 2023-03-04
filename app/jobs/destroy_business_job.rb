# frozen_string_literal: true

class DestroyBusinessJob < ApplicationJob
  def perform(business_id)
    ActiveRecord::Base.connection_pool.with_connection do
      business = Business.with_deleted.find(business_id)
      business.destroy
    end
  end
end
