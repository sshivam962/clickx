# frozen_string_literal: true

module Businesses
  module Backlinks
    class UpdateTopicsUpdatedDate
      def initialize(business)
        @business = business
      end

      def call
        return unless business.backlink_service
        update_topics_updated_at
      end

      private

      attr_accessor :business

      def update_topics_updated_at
        updated_at = @business.backlink_datum.topics_updated_at
        return unless updated_at.blank? || updated_at > 7.days.ago
        response = Majestic.get_topics(@business.domain)
        business
          .backlink_datum
          .update(
            topics: response,
            topics_updated_at: Time.now
          )
        business.backlink_datum
      end
    end
  end
end
