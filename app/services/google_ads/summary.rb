class GoogleAds::Summary < GoogleAds::Base
  def fetch
    this_period = send_query(query(*current_dates))
    @this_period = prepare_response(this_period)
    total_details = send_query(total_query(*current_dates))
    @total_details = prepare_totals(total_details)

    if previous_dates.all?
      last_period = send_query(query(*previous_dates))
      @last_period = prepare_response(last_period)
    end

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
      FROM campaign
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
        metrics.clicks,
        metrics.impressions,
        metrics.average_cost,
        metrics.conversions,
        metrics.interactions
      FROM campaign
      WHERE
        campaign.id IN (#{campaign_ids.join(',')})
        AND segments.date BETWEEN '#{start_date}' AND '#{end_date}'
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
    totals = blank_hash

    data.each do |row|
      metrics = row.metrics

      totals[:clicks] += metrics.clicks
      totals[:impressions] += metrics.impressions
      totals[:cost] += cost(metrics.average_cost, metrics.interactions)
      totals[:conversions] += metrics.conversions
      totals[:interactions] += metrics.interactions
    end

    totals[:ctr] = ctr(totals[:clicks], totals[:impressions])
    totals[:average_cost] = totals[:cost] / (totals[:interactions].zero? ? 1 : totals[:interactions])

    totals
  end
end
