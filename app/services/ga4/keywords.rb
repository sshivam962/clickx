class GA4::Keywords < GA4::Base
  def fetch
    {
      keyword_stats: keywords_data(*current_dates)
    }
  end

  private

  def keywords_data(start_date, end_date)
    query_params = {
      "dimensions": [
        { "name":"sessionGoogleAdsKeyword" }
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
