class SemrushKeywordsJob
  include Sidekiq::Worker
  sidekiq_options queue: 'kw_priority_queue'

  def perform(business_id)
    business = Business.find(business_id)

    return if business.semrush_project_id.blank?
    return if business.semrush_project_url.blank?

    total_keywords = 100
    limit = 100
    offset = 0

    while offset < total_keywords
      response = Semrush.keywords_ranking(
        business.semrush_project_id,
        business.rank_tracking_url,
        limit, offset
      )

      total_keywords = response[:total] || 0
      store_keywords(business, response[:keywords])

      offset += limit
    end
  end

  def store_keywords(business, keywords)
    return if keywords.blank?

    keywords.each do |k|
      rank = k['rank'].to_i
      next if rank.zero? || rank > 100

      keyword = business.semrush_keywords.find_or_create_by(name: k['name'])
      last_day_google_change = k['last_day_google_change'].eql?('-') ? nil : k['last_day_google_change']

      keyword.update(
        cpc: k['cpc'],
        url: k['url'],
        rank: rank,
        last_day_google_change: last_day_google_change
      )

      # keyword.set_kdi if keyword.kdi_updatable?
      keyword.set_search_volume if keyword.volume_updatable?
    end
  end
end
