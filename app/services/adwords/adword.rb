# frozen_string_literal: true

module Adwords
  class Adword
    attr_accessor :business, :token, :client_id
    def initialize(business, client_id, type = 'adword')
      @business = business
      @client_id = client_id
      @token = AdwordsAuth.access_token(business: business, type: type)
      @token ||= Token.find_by(code_type: Token::AdwordAccessToken)
    end

    def api_client
      adword_client = AdwordsAuth.adword_client
      AdwordsAuth.set_credentials(adword_client, token, client_id)
      adword_client
    end

    def ad_service
      api_client.service(:AdGroupAdService, AdwordsAuth::API_VERSION)
    end

    def campaign_criterion_srv
      api_client.service(:CampaignCriterionService, AdwordsAuth::API_VERSION)
    end

    def report_utils
      api_client.report_utils(AdwordsAuth::API_VERSION)
    end

    def send_query(query, start_date, end_date)
      date_range = date_range_from_duration(start_date, end_date)

      report_query = query % date_range

      signature = Digest::SHA1.digest(report_query)
      Rails.cache.fetch(signature, expires_in: CACHE_DURATION) do
        report_utils.download_report_with_awql(report_query, 'CSV')
      end
    end

    def access_details
      customer_service = api_client.service(:CustomerService, AdwordsAuth::API_VERSION)
      customer_service.get_customers(client_id)
    rescue AdsCommon::Errors::AuthError
      []
    end

    def campaigns
      data = []
      query = 'SELECT CampaignId, CampaignName, AdvertisingChannelType FROM CAMPAIGN_PERFORMANCE_REPORT '
      report = CSV.parse(report_utils.download_report_with_awql(query, 'CSV'))
      report.delete_at(-1)
      report.drop(2).each do |row|
        data.push(id: row[0], name: row[1], type: row[2])
      end
      data
    end

    private

    def date_range_from_duration(start_date, end_date)
      format('%s,%s', start_date.to_date.strftime('%Y%m%d'), end_date.to_date.strftime('%Y%m%d'))
    end
  end
end
