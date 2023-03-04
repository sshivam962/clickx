# frozen_string_literal: true

module Businesses
  module AdWords
    CLIENT_ID = {
      'adword' => 'adword_client_id',
      'ppc' => 'adword_client_id'
    }.freeze
    CAMPAIGN_ID = {
      'adword' => 'adword_campaign_ids'
    }.freeze

    class Disconnect
      class InvalidKey < StandardError; end

      def initialize(business:, type:)
        @business = business
        @type = type || 'adword'
      end

      def call
        raise InvalidKey unless access_token_key.keys.include? type
        disconnect
      end

      private

      attr_accessor :business, :type

      def disconnect
        Business.transaction do
          business.tokens
                  .where(code_type: access_token_key[type])
                  .destroy_all
          business.update(CLIENT_ID[type] => nil, CAMPAIGN_ID[type] => nil)
          # AdwordsMailer.disconnect_account(business, type).deliver_later
        end
      end

      def access_token_key
        @_access_token_key ||= Businesses::AdwordsController::ACCESS_TOKEN_KEY
      end
    end
  end
end
