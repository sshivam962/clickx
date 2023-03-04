class GA4::Campaigns < GA4::Base
  def fetch
    {
      campaigns: campaigns_data(*current_dates)
    }
  end

  private

  def campaigns_data(start_date, end_date)
    query_params = {
      "dimensions": [
        { "name":"campaignName" }
      ],
      "metrics": [
        { "name":"sessions" },
        { "name":"newUsers" },
        { "name":"screenPageViewsPerSession" },
        { "name":"averageSessionDuration" },
        { "name":"bounceRate" }
      ],
      "dateRanges": [
        { "startDate": start_date, "endDate": end_date }
      ]
    }
    parse_report_response(run_report(query_params))
  end
end
