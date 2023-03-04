class GA4::Referrals < GA4::Base
  def fetch
    {
      referrals: referrals_data(*current_dates)
    }
  end

  private

  def referrals_data(start_date, end_date)
    query_params = {
      "dimensions": [
        { "name":"sessionSource" }
      ],
      "metrics": [
        { "name":"totalUsers" },
        { "name":"sessions" },
        { "name":"screenPageViews" },
        { "name":"screenPageViewsPerSession" },
        { "name":"averageSessionDuration" },
        { "name":"bounceRate" },
      ],
      "dateRanges": [
        { "startDate": start_date, "endDate": end_date }
      ]
    }
    parse_report_response(run_report(query_params))
  end
end
