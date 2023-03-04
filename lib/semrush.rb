# frozen_string_literal: true
module Semrush
  URL = 'https://api.semrush.com/'
  ACCOUNT_API_URL = "https://www.semrush.com/users/countapiunits.html?key=#{ENV['SEMRUSH_API_KEY']}"

  module_function

  # API Units : 10
  def domain_overview(domain_url)
    resp = Faraday.get(URL) do |req|
      req.params['key'] = ENV['SEMRUSH_API_KEY']
      req.params['type'] = 'domain_rank'
      req.params['export_columns'] = 'Dn,Rk,Or,Ot,Oc,Ad,At,Ac'
      req.params['database'] = 'us'
      req.params['domain'] = domain_url
    end

    details = []
    CSV.parse(resp.body.force_encoding('utf-8'), col_sep: ';').drop(1).each do |row|
      details.push(domain: row[0],
                   rank: row[1].to_i,
                   organic_keywords: row[2].to_i,
                   organic_traffic: row[3].to_i,
                   organic_cost: row[4].to_f,
                   adwords_keywords: row[5].to_i,
                   adwords_traffic: row[6].to_i,
                   adwords_cost: row[7].to_f)
    end

    details.first || {}
  end

  def domain_traffic_history(domain_url)
    resp = Faraday.get(URL) do |req|
      req.headers['accept-encoding'] = 'none'
      req.params['key'] = ENV['SEMRUSH_API_KEY']
      req.params['type'] = 'domain_rank_history'
      req.params['export'] = 'api'
      req.params['display_sort'] = 'dt_desc'
      req.params['display_limit'] = '24'
      req.params['database'] = 'us'
      req.params['domain'] = domain_url
    end
    parse_csv(resp.body)
  end

  def keywords_data(domain_url, type)
    resp = Faraday.get(URL) do |req|
      req.params['key'] = ENV['SEMRUSH_API_KEY']
      req.params['type'] = type
      req.params['export_columns'] = 'Ph,Po,Pp,Pd,Nq,Cp,Ur,Tr,Tc'
      req.params['display_sort'] = 'tr_desc'
      req.params['display_limit'] = '100'
      req.params['database'] = 'us'
      req.params['domain'] = domain_url
    end

    details = []
    CSV.parse(resp.body.force_encoding('utf-8'), col_sep: ';').drop(1).each do |row|
      details.push(keyword: row[0],
                   position: row[1].to_i,
                   prev_position: row[2].to_i,
                   prev_diff: row[3].to_i,
                   search_volume: row[4].to_i,
                   cpc: row[5].to_f,
                   url: row[6],
                   traffic: row[7].to_f,
                   traffic_cost: row[8].to_f)
    end
    details
  end

  # API Units : 10 * display_limit = 1000
  def organic_keywords(domain_url)
    keywords_data domain_url, 'domain_organic'
  end

  # API Units : 20 * display_limit = 2000
  def adwords_keywords(domain_url)
    keywords_data domain_url, 'domain_adwords'
  end

  # API Units : 40 * display_limit = 400
  def competitors_organic(domain_url)
    resp = Faraday.get(URL) do |req|
      req.params['key'] = ENV['SEMRUSH_API_KEY']
      req.params['type'] = 'domain_organic_organic'
      req.params['export_columns'] = 'Dn,Cr,Np,Or,Ot,Oc'
      req.params['display_sort'] = 'tr_desc'
      req.params['display_limit'] = '10'
      req.params['database'] = 'us'
      req.params['domain'] = domain_url
    end

    details = []
    CSV.parse(resp.body.force_encoding('utf-8'), col_sep: ';').drop(1).each do |row|
      details.push(domain: row[0],
                   competitor_relevance: row[1].to_f,
                   common_keywords: row[2].to_i,
                   organic_keywords: row[3].to_i,
                   organic_traffic: row[4].to_i,
                   organic_cost: row[5].to_f)
    end
    details
  end

  # API Units : 40 * display_limit = 400
  def competitors_adwords(domain_url)
    resp = Faraday.get(URL) do |req|
      req.params['key'] = ENV['SEMRUSH_API_KEY']
      req.params['type'] = 'domain_adwords_adwords'
      req.params['export_columns'] = 'Dn,Cr,Np,Ad,At,Ac'
      req.params['display_sort'] = 'tr_desc'
      req.params['display_limit'] = '10'
      req.params['database'] = 'us'
      req.params['domain'] = domain_url
    end

    details = []
    CSV.parse(resp.body.force_encoding('utf-8'), col_sep: ';').drop(1).each do |row|
      details.push(domain: row[0],
                   competitor_relevance: row[1].to_f,
                   common_keywords: row[2].to_i,
                   adwords_keywords: row[3].to_i,
                   adwords_traffic: row[4].to_i,
                   adwords_cost: row[5].to_f)
    end
    details
  end

  # API Units : 20 * display_limit = 20
  def keyword_search_volume(keyword_phrase)
    resp = Faraday.get(URL) do |req|
      req.params['key'] = ENV['SEMRUSH_API_KEY']
      req.params['type'] = 'phrase_this'
      req.params['export_columns'] = 'Ph,Nq,Cp'
      req.params['display_limit'] = '1'
      req.params['database'] = 'us'
      req.params['phrase'] = keyword_phrase
    end

    details = []
    begin
      CSV.parse(resp.body.force_encoding('utf-8'), col_sep: ';').drop(1).each do |row|
        details.push(keyword_phrase: row[0],
                     search_volume: row[1],
                     cpc: row[2])
      end
    rescue CSV::MalformedCSVError
      # Do nothing, just skip
    end
    details
  end

  # API Units : 40 * display_limit = 1000
  def related_keywords(keyword_phrase)
    resp = Faraday.get(URL) do |req|
      req.params['key'] = ENV['SEMRUSH_API_KEY']
      req.params['type'] = 'phrase_related'
      req.params['export_columns'] = 'Ph,Nq'
      req.params['display_limit'] = '10'
      req.params['database'] = 'us'
      req.params['display_sort'] = 'nq_desc'
      req.params['phrase'] = keyword_phrase
    end

    details = []
    CSV.parse(resp.body.force_encoding('utf-8'), col_sep: ';').drop(1).each do |row|
      details.push(keyword_phrase: row[0],
                   search_volume: row[1])
    end

    details
  end

  # API Units : 50
  def keyword_difficulty(keyword_phrase)
    resp = Faraday.get(URL) do |req|
      req.params['key'] = ENV['SEMRUSH_API_KEY']
      req.params['type'] = 'phrase_kdi'
      req.params['export_columns'] = 'Ph,Kd'
      req.params['database'] = 'us'
      req.params['phrase'] = keyword_phrase
    end
    details = {
      keyword_phrase: nil,
      keyword_difficulty: nil
    }
    CSV.parse(resp.body.force_encoding('utf-8'), col_sep: ';').drop(1).each do |row|
      details[:keyword_phrase] = row[0]
      details[:keyword_difficulty] = row[1]
    end
    details
  end

  def self.api_credit_balance
    resp = Faraday.get(ACCOUNT_API_URL)
    resp.body.to_i
  end

  def parse_csv(text = '')
    return [] if text.empty?
    csv = CSV.parse(text.to_s, col_sep: ';')

    format_key = lambda do |k|
      r = {
        /\s/ => '_',
        /[\.\)|\(]/ => '',
        /%/ => 'percent',
        /\*/ => 'times'
      }
      k = k.to_s.downcase
      r.each_pair {|pattern, replace| k.gsub!(pattern, replace) }
      k.to_sym
    end

    keys = csv.shift.map(&format_key)
    string_data = csv.map { |row| row.map { |cell| cell&.to_numeric || 0 } }
    data = string_data.map { |row| Hash[*keys.zip(row).flatten] }
    data.each do |row|
      row[:date] = Date.parse(row[:date].to_s).to_time.to_i * 1000 if row[:date]
    end
    data
  rescue CSV::MalformedCSVError => csvife
    tries ||= 0
    if (tries += 1) < 3
      retry
    else
      raise CSV::MalformedCSVError.new("Bad format for CSV: #{text.inspect}").tap{ |e|
        e.set_backtrace(csvife.backtrace)
      }
    end
  end

  # Get url of a project from SEMrush.
  def fetch_project(project_id)
    project_id = project_id.to_s.split('_').first
    project_details_api_url = "https://api.semrush.com/management/v1/projects/#{project_id}"

    resp = Faraday.get(project_details_api_url) do |req|
      req.params[:key] = ENV['SEMRUSH_API_KEY']
    end

    json_parsed = JSON.parse(resp.body)
    json_parsed['status'] = resp.status

    json_parsed
  end

  # Get all keywords from a project in SEMrush.
  # Includes project id and campaign id like : XXXXX_XXXXX for new projects.
  def keywords_ranking(project_id, url, limit=100, offset=0)
    project_api_url = "https://api.semrush.com/reports/v1/projects/#{project_id}/tracking/"
    project_url =
      if url.split('.').count > 2
        url + "/*"
      else
        "*" + url + "/*"
      end

    resp = Faraday.get(project_api_url) do |req|
      req.params[:key] = ENV['SEMRUSH_API_KEY']
      req.params[:action] = 'report'
      req.params[:type] = 'tracking_position_organic'
      req.params[:url] = project_url
      req.params[:display_limit] = limit
      req.params[:display_offset] = offset
    end

    json_parsed = JSON.parse(resp.body)
    total_count = json_parsed['total']

    keywords = json_parsed['data']&.map do |k, v|
      latest_date = v['Dt'].max_by{ |d| d.first.to_i }.first
      {
        'name' => v['Ph'],
        'cpc' => v['Cp'],
        'url' => v['Lu'][latest_date].values.first,
        'rank' => v['Dt'][latest_date].values.first,
        'last_day_google_change' => v['Diff1'].values.first
      }
    end

    { total: total_count, keywords: keywords }
  end

  # For getting search volume of a keyword (Used in the workflow when a businesses semrush_project_id is given).
  def semrush_keyword_search_volume(phrase)
    resp = Faraday.get(URL) do |req|
      req.params[:key] = ENV['SEMRUSH_API_KEY']
      req.params[:type] = 'phrase_this'
      req.params[:phrase] = phrase
      req.params[:database] = "us"
    end

    details = {
      search_volume: nil
    }
    CSV.parse(resp.body.force_encoding('utf-8'), col_sep: ';').drop(1).each do |row|
      details[:search_volume] = row[1]
    end

    details
  end

  def add_keyword_to_project(project_id, keywords)
    url = "https://api.semrush.com/management/v1/projects/#{project_id}/keywords"

    resp = Faraday.put(url) do |req|
      req.params[:key] = ENV['SEMRUSH_API_KEY']
      req.params[:keywords] = keywords
    end

    resp.status
  end

end
