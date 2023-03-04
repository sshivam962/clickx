class GoogleAds::Keywords < GoogleAds::Base
  def fetch
    this_period = send_query(query(*current_dates))
    last_period = send_query(query(*previous_dates))
    total_details = send_query(total_query(*current_dates))

    @this_period = prepare_response(this_period)
    @last_period = prepare_response(last_period)
    @total_details = prepare_totals(total_details)

    {
      this_period: @this_period,
      total_details: @total_details,
      last_period: @last_period
    }
  end

  def top_10_keywords
    total_details = send_query(total_query(*current_dates))
    prepare_totals(total_details)
  end

  private

  def query(start_date, end_date)
    <<~QUERY
      SELECT
        metrics.clicks,
        metrics.impressions,
        metrics.average_cost,
        metrics.conversions,
        metrics.interactions,
        segments.date
      FROM keyword_view
      WHERE
        campaign.id IN (#{campaign_ids.join(',')})
        AND segments.date BETWEEN '#{start_date}' AND '#{end_date}'
      ORDER BY
        segments.date
    QUERY
  end

  def total_query(start_date, end_date)
    <<~QUERY
      SELECT
        ad_group_criterion.keyword.text,
        ad_group_criterion.keyword.match_type,
        metrics.clicks,
        metrics.impressions,
        metrics.average_cost,
        metrics.conversions,
        metrics.interactions,
        metrics.search_impression_share
      FROM keyword_view
      WHERE
        campaign.id IN (#{campaign_ids.join(',')})
        AND metrics.impressions > 0
        AND segments.date BETWEEN '#{start_date}' AND '#{end_date}'
      ORDER BY
        metrics.impressions DESC
      #{'LIMIT 10' if limit}
    QUERY
  end

  def prepare_response(data)
    response = {}

    data.map do |row|
      metrics = row.metrics
      date = row.segments.date

      response[date] ||= blank_hash

      response[date][:clicks] += metrics.clicks
      response[date][:impressions] += metrics.impressions
      response[date][:cost] += cost(metrics.average_cost, metrics.interactions)
      response[date][:conversions] += metrics.conversions
      response[date][:ctr] += ctr(metrics.clicks, metrics.impressions)
      response[date][:interactions] += metrics.interactions
    end

    response
  end

  def prepare_totals(data)
    data.map do |row|
      metrics = row.metrics
      keyword = row.ad_group_criterion.keyword

      response = blank_hash

      response[:keyword] = keyword.text
      response[:match_type] = keyword.match_type
      response[:average_cost] = metrics.average_cost.to_f / 1000000
      response[:clicks] = metrics.clicks
      response[:impressions] = metrics.impressions
      response[:interactions] = metrics.interactions
      response[:cost] = cost(metrics.average_cost, metrics.interactions)
      response[:conversions] = metrics.conversions
      response[:ctr] = ctr(metrics.clicks, metrics.impressions)
      response[:search_impression_share] = metrics.search_impression_share * 100

      response
    end
  end
end
