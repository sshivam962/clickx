# frozen_string_literal: true

class KeywordRankUpdate
  attr_reader :keyword

  def initialize(search_results, rank_date, keyword, engine, params = nil)
    @search_results = search_results
    @rank_date = rank_date
    @keyword = keyword
    @params = params
    @engine = engine
    @new_ranking = nil
    @old_rankings = nil
  end

  def create_rank
    @search_results.extend(Hashie::Extensions::DeepLocate)
    results = @search_results.deep_locate ->(key, _value, _object) { key == 'base_url' }
    @domains = results.map { |r| r['base_url'] }

    return false if keyword.business.blank?
    # competitors_rankings
    business_domain = keyword.business.domain_host
    rank = begin
             @domains.find_index(business_domain) + 1
           rescue StandardError
             nil
           end
    @new_ranking = keyword.keyword_rankings.first_or_dup_on(rank_date: @rank_date)
    @old_rankings =
      keyword.keyword_rankings
             .where("#{@engine}_rank is not null")
             .order("rank_date, #{@engine}_rank desc")
             .where('rank_date >= ?', Time.zone.today.beginning_of_year)
    @new_ranking.send("#{@engine}_rank=", rank) if rank
    create_rank_change if keyword.keyword_rankings.size > 1
    create_latest_kr_data(keyword)
    url = begin
            results[rank - 1]['href']
          rescue StandardError
            nil
          end
    @new_ranking["#{@engine}_url"] = url if url

    @new_ranking["#{@engine}_callback_updated_at"] = Time.current
    @new_ranking["#{@engine}_raw_data"] = @params
    @new_ranking.save
  end

  private

  def create_rank_change
    prev_ranking = @old_rankings.last
    all_time_rank_change =
      begin
        @new_ranking["#{@engine}_rank"] - @old_rankings.first["#{@engine}_rank"]
      rescue StandardError
        nil
      end
    this_month_rank_change = begin
      @new_ranking["#{@engine}_rank"] - @old_rankings.this_month.first["#{@engine}_rank"]
    rescue StandardError
      nil
    end
    last_sevendays_change = begin
      @new_ranking["#{@engine}_rank"] - @old_rankings.last_sevendays.first["#{@engine}_rank"]
    rescue StandardError
      nil
    end
    last_30_days_change = begin
      @new_ranking["#{@engine}_rank"] - @old_rankings.last_30_days.first["#{@engine}_rank"]
    rescue StandardError
      nil
    end

    rank_change =
      if prev_ranking.present?
        begin
          @new_ranking["#{@engine}_rank"] - prev_ranking["#{@engine}_rank"]
        rescue StandardError
          nil
        end
      end

    @new_ranking["all_time_#{@engine}_change"] = all_time_rank_change
    @new_ranking["this_month_#{@engine}_change"] = this_month_rank_change
    @new_ranking["last_sevendays_#{@engine}_change"] = last_sevendays_change
    @new_ranking["last_30_days_#{@engine}_change"] = last_30_days_change
    @new_ranking["#{@engine}_change"] = rank_change
  end

  def create_latest_kr_data(keyword)
    latest_kr_data = keyword.keyword_rankings.order('rank_date DESC').first
    if latest_kr_data.present? && latest_kr_data.has_keyword_info?
      @new_ranking.search_volume = latest_kr_data.search_volume
      @new_ranking.cpc = latest_kr_data.cpc
    else
      search_volume_data = Semrush.keyword_search_volume(@keyword.name).first
      if search_volume_data.present?
        @new_ranking.search_volume = search_volume_data[:search_volume]
        @new_ranking.cpc = search_volume_data[:cpc]
      end
    end
  end

  def competitors_rankings
    @domains.each_with_index.map do |domain, index|
      rank = begin
          index + 1
        rescue StandardError
          nil
        end
      competitors_ranking = DomainRanking.first_or_dup_on(rank_date: @rank_date, keyword_name: keyword.name,
                                                          domain: domain)
      competitors_ranking.rank = rank
      competitors_ranking.save!
    end
  end
end
