class GoogleAds::Base
  attr_reader :business,
    :current_start_date, :current_end_date,
    :previous_start_date, :previous_end_date,
    :login_customer_id, :campaign_ids,
    :cost_markup, :limit

  PAGE_SIZE = 1000

  def initialize(business, current_start_date: nil, current_end_date: nil, previous_start_date: nil, previous_end_date: nil, limit: nil)
    @business = business
    @login_customer_id = business.google_ads_login_customer_id
    @campaign_ids = business.adword_campaign_ids
    @cost_markup = business.adword_cost_markup.to_i

    @current_start_date = current_start_date
    @current_end_date = current_end_date
    @previous_start_date = previous_start_date
    @previous_end_date = previous_end_date
    @limit = limit
  end

  def self.fetch(*args)
    new(*args).fetch
  end

  private

  def send_query(query)
    client.service.google_ads.search(
      customer_id: business.google_ads_customer_client_id,
      query: query,
      page_size: PAGE_SIZE
    )
  end

  def client
    @_client ||= GoogleAds.new(
      token: business.tokens.of_type(Token::GoogleAdsToken).first,
      customer_id: login_customer_id
    ).client
  end

  def current_dates
    [current_start_date, current_end_date]
  end

  def previous_dates
    [previous_start_date, previous_end_date]
  end

  def blank_hash
    {
      clicks: 0, impressions: 0,
      cost: 0, conversions: 0,
      ctr: 0, interactions: 0
    }
  end

  def ctr(clicks, impressions)
    ((clicks.to_f / impressions.to_f) * 100).round(2)
  end

  def cost(average_cost, interactions)
    cost = average_cost * interactions
    (cost.to_i + ((cost.to_i / 100) * cost_markup))
  end
end
