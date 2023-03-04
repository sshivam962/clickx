# frozen_string_literal: true

module Adwords
  class Geo
    PAGE_SIZE = 500

    attr_accessor :business, :customer_id, :campaign_id, :campaign_ids

    def initialize(business_id, campaign_id = nil)
      @business = Business.find(business_id)
      @customer_id = @business.adword_client_id
      @campaign_id = campaign_id
    end

    def fetch
      geo_targets = client.campaign_criterion_srv.get(selector)

      targets = []
      geo_targets[:entries].each do |geo_target|
        parent_ids = geo_target[:criterion][:parent_locations]&.pluck(:id)
        targets << geo_target[:criterion].slice(
          :id, :location_name, :display_type, :targeting_status
        ).merge(
          is_negative: geo_target[:is_negative],
          parent_locations: parent_ids
        )
      end

      targets
    end

    private

    def client
      @_client ||= Adwords::Adword.new(business, business.adword_client_id, 'adword')
    end

    def selector
      {
        fields: ['CampaignId', 'Id', 'CriteriaType', 'LocationName'],
        predicates: [
          {field: 'CampaignId', operator: 'EQUALS', values: [campaign_id]},
          {field: 'CriteriaType', operator: 'EQUALS', values: ['LOCATION']}
        ],
        paging: {
          start_index: 0,
          number_results: PAGE_SIZE
        }
      }
    end
  end
end
