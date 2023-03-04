# frozen_string_literal: true
module Businesses
  module Backlinks
    class UpdateRefDomainsUpdatedDate
      def initialize(business)
        @business = business
      end

      def call
        return unless business.backlink_service
        update_ref_domains_updated_at
      end

      private

      attr_accessor :business

      def update_ref_domains_updated_at
        updated_at = @business.backlink_datum.ref_domains_updated_at
        return business.backlink_datum unless updated_at.blank? || updated_at < 7.days.ago
        response = Majestic.get_ref_domain(@business.domain)
        business
          .backlink_datum
          .update(
            ref_domains: response,
            ref_domains_updated_at: Time.now
          )
        business.backlink_datum
      end
    end
  end
end
