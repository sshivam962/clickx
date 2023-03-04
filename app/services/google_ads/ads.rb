class GoogleAds::Ads < GoogleAds::Base
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
      FROM ad_group_ad
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
        ad_group_ad.ad.text_ad.headline,
        ad_group_ad.ad.text_ad.description1,
        ad_group_ad.ad.text_ad.description2,
        ad_group_ad.ad.display_url,
        metrics.clicks,
        metrics.impressions,
        metrics.average_cost,
        metrics.ctr,
        metrics.conversions,
        metrics.interactions,
        ad_group_ad.ad.type,
        ad_group_ad.ad.image_ad.image_url,
        ad_group_ad.ad.final_urls,
        ad_group_ad.ad.expanded_text_ad.headline_part1,
        ad_group_ad.ad.expanded_text_ad.headline_part2,
        ad_group_ad.ad.expanded_text_ad.headline_part3,
        ad_group.name,
        ad_group_ad.status
      FROM ad_group_ad
      WHERE
        campaign.id IN (#{campaign_ids.join(',')})
        AND metrics.impressions > 0
        AND segments.date BETWEEN '#{start_date}' AND '#{end_date}'
      ORDER BY
        ad_group.name
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

      response = blank_hash

      response[:average_cost] = metrics.average_cost.to_f / 1000000
      response[:clicks] = metrics.clicks
      response[:impressions] = metrics.impressions
      response[:cost] = cost(metrics.average_cost, metrics.interactions)
      response[:conversions] = metrics.conversions
      response[:ctr] = ctr(metrics.clicks, metrics.impressions)

      response
    end
  end
end
