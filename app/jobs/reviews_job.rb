# frozen_string_literal: true

class ReviewsJob < ApplicationJob
  def perform(location)
    ActiveRecord::Base.connection_pool.with_connection do
      location.fetch_latest_reviews
    end
  end
end
