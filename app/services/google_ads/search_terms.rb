class GoogleAds::SearchTerms < GoogleAds::Base
  def fetch
    total_details = send_query(total_query(*current_dates))
    @total_details = prepare_totals(total_details)

    {
      total_details: @total_details,
    }
  end

  private

  def total_query(start_date, end_date)
    <<~QUERY
      SELECT
        search_term_view.search_term,
        segments.search_term_match_type,
        segments.keyword.info.text,
        metrics.clicks,
        metrics.impressions,
        metrics.average_cost,
        metrics.conversions,
        metrics.interactions
      FROM search_term_view
      WHERE
        campaign.id IN (#{campaign_ids.join(',')})
        AND metrics.impressions > 0
        AND segments.date BETWEEN '#{start_date}' AND '#{end_date}'
      ORDER BY
        search_term_view.search_term
    QUERY
  end

  def prepare_totals(data)
    data.map do |row|
      metrics = row.metrics
      search_term = row.search_term_view
      keyword = row.segments.keyword.info
      segments = row.segments

      response = blank_hash

      response[:query] = search_term.search_term
      response[:keyword] = keyword.text
      response[:match_type] = segments.search_term_match_type
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
