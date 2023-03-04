class GA4::Locales < GA4::Base
  def fetch
    {
      locales_stats: locales_data(*current_dates)
    }
  end

  private

  def locales_data(start_date, end_date)
    query_params = {
      "dimensions": [
        { "name":"country" }
      ],
      "metrics": [
        { "name":"sessions" },
        { "name":"totalUsers" },
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
