class GA4::TopPages < GA4::Base
  def fetch
    {
      pages_stats: pages_data(*current_dates)
    }
  end

  private

  def pages_data(start_date, end_date)
    query_params = {
      "dimensions": [
        { "name":"pagePath" }
      ],
      "metrics": [
        { "name":"sessions" },
        { "name":"screenPageViews" },
        { "name":"averageSessionDuration" },
        { "name":"screenPageViewsPerSession" }
      ],
      "dateRanges": [
        { "startDate": start_date, "endDate": end_date }
      ]
    }
    parse_report_response(run_report(query_params))
  end
end
