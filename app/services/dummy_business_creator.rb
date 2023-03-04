# frozen_string_literal: true

class DummyBusinessCreator
  def initialize; end

  def run
    return Business.dummy.first if Business.dummy.exists?
    @business = Business.create!(business_params)
    create_competitors
  end

  private

  attr_accessor :business

  def create_competitors
    @business.competitions.create!(
      [
        {
          name: 'google.com'
        },
        {
          name: 'apple.com'
        },
        {
          name: 'microsoft.com'
        },
        {
          name: 'clickx.io'
        }
      ]
    )
  end

  def business_params
    {
      name: 'Bluth Business (DEMO)',
      agency: agency,
      domain: 'https://example.com',
      site_url: 'https://example.com',
      dummy: true,
      call_analytics_service: true,
      contents_service: true,
      seo_service: true,
      google_analytics_id: '1234',
      adword_client_id: '1234',
      competitors_limit: 5,
      backlink_service: true
    }
  end

  def agency
    Agency.first || FactoryBot.create(:agency)
  end
end
