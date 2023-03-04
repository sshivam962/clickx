class GA4::Dashboard < GA4::Base
  def fetch
    {
      dashboard_data: fetch_dashboard_data(*current_dates)
    }
  end

  private

  def fetch_dashboard_data(start_date, end_date)
    query_params = {
      "metrics": [
        { "name":"sessions" },
        { "name":"totalUsers" },
        { "name":"screenPageViews" },
        { "name":"averageSessionDuration" },
        { "name":"bounceRate" },
        { "name":"activeUsers" },
        { "name":"eventsPerSession" },
        { "name":"newUsers" },
        { "name":"screenPageViewsPerSession" },
      ],
      "dateRanges": [
        { "startDate": start_date, "endDate": end_date }
      ]
    }
    parse_report_response(run_report(query_params))
  end
end
