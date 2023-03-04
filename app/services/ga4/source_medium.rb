class GA4::SourceMedium < GA4::Base
  def fetch
    {
      source_medium: source_medium_data(*current_dates)
    }
  end

  private

  def source_medium_data(start_date, end_date)
    query_params = {
      "dimensions": [
        { "name":"sourceMedium" }
      ],
      "metrics": [
        { "name":"sessions" },
        { "name":"screenPageViews" },
        { "name":"screenPageViewsPerSession" },
        { "name":"averageSessionDuration" },
        { "name":"bounceRate" },
        { "name":"newUsers" },
      ],
      "dateRanges": [
        { "startDate": start_date, "endDate": end_date }
      ]
    }
    parse_report_response(run_report(query_params))
  end
end
