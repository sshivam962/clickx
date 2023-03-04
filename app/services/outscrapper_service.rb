# frozen_string_literal: true
module OutscrapperService
  BASE_URL = "https://api.app.outscraper.com"

  module_function

  def search(query, limit)
    url = "#{BASE_URL}/maps/search"
    Faraday.get(url) do |req|
      req.headers['X-API-KEY'] = ENV['OUTSCRAPER_API_KEY']
      req.params['query'] = query.join(', ')
      req.params['extractContacts'] = true
      req.params['dropDuplicates'] = true
      req.params['async'] = true
      req.params['limit']= limit
      req.params['enrichments']= 'companies_data,emails_validator_service'
    end
  end

  def search_v2(query_combination, limit)
    query_array = []
    query_combination.take(25).each do |combination|
      query_array << combination.join(" ")
    end
    url = "#{BASE_URL}/maps/search-v2"
    Faraday.get(url) do |req|
      req.headers['X-API-KEY'] = ENV['OUTSCRAPER_API_KEY']
      req.params = {'query': query_array }
      req.params['extractContacts'] = true
      req.params['dropDuplicates'] = true
      req.params['async'] = true
      req.params['limit']= limit
      req.params['enrichments']= 'companies_data,emails_validator_service'
    end
  end

  def advanced_search_v2(query, limit)
    url = "#{BASE_URL}/maps/search-v2"
    Faraday.get(url) do |req|
      req.headers['X-API-KEY'] = ENV['OUTSCRAPER_API_KEY']
      req.params['query'] = query
      req.params['extractContacts'] = true
      req.params['dropDuplicates'] = true
      req.params['async'] = true
      req.params['limit']= limit
      req.params['enrichments']= 'companies_data,emails_validator_service'
    end
  end

  def reorder_search_v2(url)
    Faraday.get(url) do |req|
      req.headers['X-API-KEY'] = ENV['OUTSCRAPER_API_KEY']
    end
  end

  def specific_data_search(id)
    url = "#{BASE_URL}/requests/#{id}"
    resp = Faraday.get(url)
    gz = Zlib::GzipReader.new(StringIO.new(resp.body.to_s))
    uncompressed_string = gz.read
    JSON.parse(uncompressed_string) if resp.status == 200
  end

  def add_to_outscrapper_data(outscrapper_request, response_data, lead_source_id)
    if response_data['data'].blank?
      Raven.capture_exception(
        "Outscrapper data is blank for request id: #{outscrapper_request.id}"
      )
      return
    end
    lead_source = LeadSource.find_by_id(lead_source_id)
    
    if lead_source.blank?
      Raven.capture_exception(
        "Outscrapper data request id: #{outscrapper_request.id} Not Found the List"
      )
      return
    end
    cleaned_json = cleaned_response(response_data['data'])
    data = outscrapper_request.create_outscrapper_data(
      response_json: response_data['data'],
      cleaned_json: cleaned_json,
      agency_id: lead_source.agency_id, 
    )
    ImportOutscrapperDataJob.perform_async(lead_source_id, data.cleaned_json)
  end

  def cleaned_response(data)
    cleaned_data = []
    data.each do |obj|
      obj_data = {}
      emails = []
      [
        {
          email: obj['email_1'],
          name: obj['email_1_full_name']
        },
        {
          email: obj['email_2'],
          name: obj['email_2_full_name']
        },
        {
          email: obj['email_3'],
          name: obj['email_3_full_name']
        }
      ].each do |e|
        next if e[:email].blank?

        email_obj = {
          email: e[:email],
          first_name: first_name(e[:name]).capitalize,
          last_name: last_name(e[:name]).capitalize
        }

        emails.push(email_obj) unless %w[gmail yahoo outlook ymail hotmail].any? {|word| e[:email].include?(word)}
      end
      next if emails.empty?

      obj_data.merge!(company_name: obj['name'])
      obj_data.merge!(type: obj['type'])
      obj_data.merge!(city: obj['city'])
      obj_data.merge!(site: obj['site'])
      obj_data.merge!(state: obj['state'])
      obj_data.merge!(instagram: obj['instagram'])
      obj_data.merge!(emails: emails)
      obj_data.merge!(phone: obj['phone'])
      obj_data.merge!(phone_1: obj['phone_1'])
      obj_data.merge!(phone_2: obj['phone_2'])
      obj_data.merge!(phone_3: obj['phone_3'])
      obj_data.merge!(full_address: obj['full_address'])
      obj_data.merge!(reviews: obj['reviews'])
      obj_data.merge!(reviews_id: obj['reviews_id'])
      obj_data.merge!(reviews_data: obj['reviews_data'])
      obj_data.merge!(reviews_link: obj['reviews_link'])
      obj_data.merge!(reviews_tags: obj['reviews_tags'])
      obj_data.merge!(reviews_per_score: obj['reviews_per_score'])
      obj_data.merge!(twitter: obj['twitter'])
      obj_data.merge!(youtube: obj['youtube'])
      obj_data.merge!(facebook: obj['facebook'])
      obj_data.merge!(website_has_fb_pixel: obj['website_has_fb_pixel'])
      obj_data.merge!(website_has_google_tag: obj['website_has_google_tag'])
      cleaned_data << obj_data
    end
    cleaned_data
  end

  def first_name(name)
    name&.split&.first || ''
  end

  def last_name(name)
    if name.present? && (name.split.count > 1)
      name.split[1..-1].join(' ')
    end || ''
  end
end
