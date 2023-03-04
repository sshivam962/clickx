class GA4::Overview < GA4::Base
  def fetch
    {
      totals: get_total_stats(*current_dates),
      visit_stats: get_visit_stats(*current_dates)
    }
  end

  private

  def get_total_stats(start_date, end_date)
    query_params = {
      "metrics": [
        { "name":"sessions" },
        { "name":"totalUsers" },
        { "name":"screenPageViews" }
      ],
      "dateRanges": [
        { "startDate": start_date, "endDate": end_date }
      ]
    }
    parse_report_response(run_report(query_params)).first || {}
  end

  def get_visit_stats(start_date, end_date)
    query_params = {
      "dimensions": [
        { "name":"sessionMedium" }
      ],
      "metrics": [
        { "name":"sessions" }
      ],
      "dateRanges": [
        { "startDate": start_date, "endDate": end_date }
      ]
    }

    visits_data = parse_report_response(run_report(query_params))

    visit_totals = {
      direct: 0, paid: 0, organic: 0, referral: 0,
      social: 0, email: 0, others: 0
    }

    visits_data.each do |data|
      medium = data['sessionMedium'].downcase
      if %w[cpa cpc cpm cpp cpv ppc].include?(medium)
        visit_totals[:paid] += data['sessions'].to_i
      elsif medium.include?('(none)')
        visit_totals[:direct] += data['sessions'].to_i
      elsif medium.include?('organic')
        visit_totals[:organic] += data['sessions'].to_i
      elsif medium.include?('email')
        visit_totals[:email] += data['sessions'].to_i
      elsif medium.include?('referral')
        visit_totals[:referral] += data['sessions'].to_i
      elsif medium.include?('social')
        visit_totals[:social] += data['sessions'].to_i
      else
        visit_totals[:others] += data['sessions'].to_i
      end
    end

    visit_totals
  end
end
