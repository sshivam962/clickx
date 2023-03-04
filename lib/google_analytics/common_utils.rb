# frozen_string_literal: true

module GoogleAnalytics
  class CommonUtils
    CACHE_DURATION = 60 * 60 * 3

    def fetch_analytics_data(profile_id, dimensions, metrics, client, params, start_date,
                             end_date, filters = nil, segments = nil, sort = nil,
                             max_results = nil)
      options = params.merge(
        'ids'        => "ga:#{profile_id}",
        'start-date' => start_date,
        'end-date'   => end_date,
        'dimensions' => dimensions,
        'metrics'    => metrics,
        'filters'    => filters,
        'segments'   => segments,
        'sort'       => sort
      )

      ids = "ga:#{profile_id}"
      signature = Digest::SHA1.digest(options.to_s)
      APICache.get(signature, cache: CACHE_DURATION, timeout: 60) do
        if max_results.nil?
          client.get_ga_data(ids, start_date, end_date, metrics,
                             dimensions: dimensions,
                             segment: segments, sort: sort)
        else
          client.get_ga_data(ids, start_date, end_date, metrics,
                             dimensions: dimensions, segment: segments,
                             sort: sort, max_results: max_results)
        end
      end
    rescue StandardError
      '{}'
    end

    def time_form(seconds)
      format = seconds < 3600 ? '%M:%S' : '%H:%M:%S'
      Time.at(seconds).utc.strftime(format)
    end

    def reset_hash_index_for_week_or_month(rows)
      count = 0
      week_or_month = 0
      year = 0
      sum = [0, 0, 0, 0, 0, 0]
      data = {}
      date = 0

      rows.each do |row|
        prev_week_or_month = week_or_month
        prev_year = year
        week_or_month = row[0]
        year = row[1].first(4)
        if prev_week_or_month == week_or_month && prev_year == year
          sum = sum.zip(row[2..7]).map { |x, y| (x.to_f + y.to_f).round(2) }
          count += 1
        else
          unless prev_week_or_month.to_i.zero?
            data[date] = [sum[0] / count, sum[1], sum[2], sum[3] / count,
                          sum[4], sum[5] / count].map { |r| r.to_f.round(2) }
          end
          date = row[1]
          count = 1
          sum = row[2..7].map { |r| r.to_f.round(2) }
        end
      end
      data[date] = [sum[0] / count, sum[1], sum[2], sum[3] / count,
                    sum[4], sum[5] / count]
      data
    end

    def reset_hash_index_for_week(rows)
      return nil unless rows
      data = {}
      rows.each do |row|
        # For leap year, there are 53 weeks(52 weeks + 2 days).(eg: 2016)
        # So google analytics gives the results with 53 weeks.
        # So `Date.commercial(2016,53,7)` will give an error.
        # for example In 2016 the week data starts in
        # Date.commerical(2016,1,7) to Date.commerical(2016,52,7) ie,2016 Jan 10 - 2017 Jan 1
        # So the begin..rescue block will ignore the error in fetching 53rd week in 2016

        week = row[0].to_i
        date = Date.commercial(row[1].to_i, week, 7).to_s.split('-').join
        data[date] = row[2..7].map { |x| x.to_f.round(2) }
      rescue StandardError
        next
      end
      data
    end

    def reset_hash_index_for_month(rows)
      return nil unless rows
      data = {}
      rows.each do |row|
        month = row[0].to_i
        year = row[1].to_i
        # In Time.zone.parse method expect month with a 2 digit value.
        # But for Jan it is 1 (contains only one digit).
        # So Time.zone.parse('2016101') will give the result as "Tue, 01 Nov 2016"
        # But our expected result is Time.zone.parse('20160101') => "Fri, 01 Jan 2016"

        date = if month.to_s.length == 1
                 Time.zone.parse("#{year}0#{month}01").to_s.split('-').join
               else
                 Time.zone.parse("#{year}#{month}01").to_s.split('-').join
               end
        data[date] = row[2..7].map { |x| x.to_f.round(2) }
      end
      data
    end

    def reset_hash_index_for_year(rows)
      return nil unless rows
      data = {}
      rows.each do |row|
        data["#{row[0]}0101"] = row[1..6].map { |r| r.to_f.round(2) }
      end
      data
    end

    def reset_hash_index_for_date(rows)
      rows
        .map do |row|
          [row[0], row[1..6].map { |r| r.to_f.round(2) }]
        end
        .to_h
    end
  end
end
