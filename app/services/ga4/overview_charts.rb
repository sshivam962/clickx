class GA4::OverviewCharts < GA4::Base
  def fetch
    {
      charts_data: generate_chart_response(chart_data(*current_dates))
    }
  end

  private

  def chart_data(start_date, end_date)
    dimensions = [graph_option, 'year']
    dimensions = [graph_option] if ['year', 'date'].include?(graph_option)

    query_params = {
      "dimensions": dimensions.map{ |d| { "name": d } },
      "metrics": [
        { "name":"sessions" },
        { "name":"totalUsers" },
        { "name":"averageSessionDuration" },
        { "name":"screenPageViewsPerSession" },
        { "name":"sessionConversionRate" },
        { "name":"bounceRate" }
      ],
      "dateRanges": [
        { "startDate": start_date, "endDate": end_date }
      ]
    }
    parse_report_response(run_report(query_params))
  end

  def generate_chart_response(data)
    chart_data = {}
    data.map do |data|
      date = get_date_for_graph(data)
      chart_data[date] = [
        data['sessions'].to_i,
        data['totalUsers'].to_i,
        data['screenPageViewsPerSession'].to_f.round(2),
        data['averageSessionDuration'].to_f.round(2),
        data['sessionConversionRate'].to_f.round(2),
        (data['bounceRate'].to_f * 100).round(2)
      ]
    rescue StandardError
      # For leap year, there are 53 weeks(52 weeks + 2 days).(eg: 2016)
      # So google analytics gives the results with 53 weeks.
      # So `Date.commercial(2016,53,7)` will give an error.
      # for example In 2016 the week data starts in
      # Date.commerical(2016,1,7) to Date.commerical(2016,52,7) ie,2016 Jan 10 - 2017 Jan 1
      # So the begin..rescue block will ignore the error in fetching 53rd week in 2016

      next
    end
    chart_data
  end

  def get_date_for_graph(data)
    case graph_option
    when 'date'
      data['date'].to_i
    when 'week'
      Date.commercial(
        data['year'].to_i, data['week'].to_i, 7
      ).to_s.split('-').join
    when 'month'
      "#{data['year']}#{data['month']}01"
    when 'year'
      "#{data['year']}0101"
    end
  end
end
