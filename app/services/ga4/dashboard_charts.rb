class GA4::DashboardCharts < GA4::Base
  def fetch
    {
      chart_data: fetch_chart_data(*current_dates)
    }
  end

  private

  def fetch_chart_data(start_date, end_date)
    query_params = {
      "dimensions": [
        { "name":"date" }
      ],
      "metrics": [
        { "name":"totalUsers" },
      ],
      "dateRanges": [
        { "startDate": start_date, "endDate": end_date }
      ]
    }
    parse_report_response(run_report(query_params))
  end
end
