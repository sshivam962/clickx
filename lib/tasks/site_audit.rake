# frozen_string_literal: true

namespace :site_audit do
  # add in scheduler
  desc 'update site audit data'
  task update_site_audit_data: :environment do
    @businesses = Business.where(site_audit_service: true)
    @businesses.find_each do |biz|
      leo_api_datum = biz.leo_api_datum
      if leo_api_datum&.project_id
        LeoApiCallbackJob.perform_async(biz.leo_project_id) if leo_api_datum.updated_at < 7.days.ago
      end
    end
  end

  # add in scheduler
  desc 'update data in leo'
  task start_crawl_in_leo: :environment do
    leo_client = LeoApi.new(ENV['LEO_API_TOKEN'])
    Business.where(site_audit_service: true).find_each do |business|
      backlinks = []
      keyword_urls = []
      leo_api_datum = business.leo_api_datum
      next unless leo_api_datum&.project_id
      if leo_api_datum.updated_at < 6.days.ago
        latest_data = Businesses::KeywordRanks.fetch(business, {})
        keyword_urls = latest_data.pluck('googleRankingUrl').compact if latest_data
        backlink_datum = business.backlink_datum
        if backlink_datum
          if backlink_datum.backlinks
            backlinks = backlink_datum.backlinks
                                      .pluck('TargetURL').compact
          end
        end
        keywords = business.keywords.pluck(:name)
        urls = (keyword_urls + backlinks).uniq.compact
        site_urls = urls.map do |url|
          url.split('://').last
        end.uniq.compact
        leo_client.update_keywords(business.leo_project_id, keywords, site_urls)
      end
    rescue NoMethodError => e
      next
    end
  end

  desc 'remove site audit data'
  task remove_site_audit_data: :environment do
    Business.find_each(batch_size: 20) do |business|
      if business.site_audit_service
        leo_api_datum = business.leo_api_datum
        if leo_api_datum&.project_id
          leo_api_datum.update_attributes(
            issues_data: nil, detailed_report: nil,
            ssl_presence: nil, xml_sitemap: nil, version_check: nil,
            check_robots: nil
          )
        end
      end
    end
  end

  desc 'Update site audit data'
  task update_data: :environment do
    Business.where(site_audit_service: true).find_each do |business|
      leo_api_datum = business.leo_api_datum
      next unless leo_api_datum&.project_id
      break unless leo_api_datum.issues_data.nil?
      leo_client = LeoApi.new(ENV['LEO_API_TOKEN'])
      response = leo_client.website_crawl_data(business.leo_project_id)
      business.leo_api_datum.update_crawl_data(response)
    end
  end

  # add in scheduler
  desc 'Start crawl if project is not yet created in site-auditor'
  task start_crawl: :environment do
    leo_client = LeoApi.new(ENV['LEO_API_TOKEN'])
    CALLBACK_URL = "#{ROOT_URL}/businesses/leo_audit_callback.json"
    Business.where(site_audit_service: true, leo_project_id: nil).find_each do |business|
      urls = BusinessTopUrls.new(business: business).fetch_top_urls
      response = leo_client.create_project(business.domain, CALLBACK_URL, nil, urls, business.total_pages_crawled)
      project_id = response.fetch('id', nil)
      next unless project_id
      business.update_attributes(leo_project_id: project_id)
      leo_api_datum = business.leo_api_datum || business.create_leo_api_datum
      leo_api_datum.update_attributes(project_id: project_id, last_crawl_created_at: Time.current)
    rescue Faraday::ConnectionFailed
      next
    end
  end

  desc 'Restart the crawl from the beggining'
  task restart_crawl: :environment do
    leo_client = LeoApi.new(ENV['LEO_API_TOKEN'])
    CALLBACK_URL = "#{ROOT_URL}/businesses/leo_audit_callback.json"
    Business.where(site_audit_service: true).find_each do |business|
      business.leo_project_id = nil
      business.leo_api_datum = nil
      business.save!
      urls = BusinessTopUrls.new(business: business).fetch_top_urls
      response = leo_client.create_project(business.domain, CALLBACK_URL, nil, urls, business.total_pages_crawled)
      project_id = response.fetch('id', nil)
      next unless project_id
      business.update_attributes(leo_project_id: project_id)
      leo_api_datum = business.create_leo_api_datum
      leo_api_datum.update_attributes(project_id: project_id, last_crawl_created_at: Time.current)
    rescue Faraday::ConnectionFailed
      next
    end
  end

  desc 'Crawl expired business'
  task crawl_for_expired: :environment do
    leo_client = LeoApi.new(ENV['LEO_API_TOKEN'])
    CALLBACK_URL = "#{ROOT_URL}/businesses/leo_audit_callback.json"
    Business.where(site_audit_service: true).find_each(batch_size: 10) do |business|
      if business.leo_api_datum.present? && business.leo_api_datum.updated_at < 7.days.ago
        business.leo_project_id = nil
        business.leo_api_datum = nil
        business.save!
        urls = BusinessTopUrls.new(business: business).fetch_top_urls
        response = leo_client.create_project(business.domain, CALLBACK_URL, nil, urls, business.total_pages_crawled)
        project_id = response.fetch('id', nil)
        next unless project_id
        business.update_attributes(leo_project_id: project_id)
        leo_api_datum = business.create_leo_api_datum
        leo_api_datum.update_attributes(project_id: project_id, last_crawl_created_at: Time.current)
      end
    rescue Faraday::ConnectionFailed
      next
    end
  end

  desc 'Recrawl particular businesses'
  task :recrawl_business_with_id, [:business_id] => [:environment] do |_task, args|
    leo_client = LeoApi.new(ENV['LEO_API_TOKEN'])
    CALLBACK_URL = "#{ROOT_URL}/businesses/leo_audit_callback.json"
    business = Business.find(args[:business_id])
    if business.leo_api_datum.present? && business.leo_api_datum.updated_at < 7.days.ago
      business.leo_project_id = nil
      business.leo_api_datum = nil
      business.save!
      urls = BusinessTopUrls.new(business: business).fetch_top_urls
      response = leo_client.create_project(business.domain, CALLBACK_URL, nil, urls, business.total_pages_crawled)
      project_id = response.fetch('id', nil)
      break unless project_id
      business.update_attributes(leo_project_id: project_id)
      leo_api_datum = business.create_leo_api_datum
      leo_api_datum.update_attributes(project_id: project_id, last_crawl_created_at: Time.current)
    end
  end

  desc 'Crawl particular businesses'
  task :crawl_business_with_id, [:business_id] => [:environment] do |_task, args|
    leo_client = LeoApi.new(ENV['LEO_API_TOKEN'])
    CALLBACK_URL = "#{ROOT_URL}/businesses/leo_audit_callback.json"
    business = Business.find(args[:business_id])
    urls = BusinessTopUrls.new(business: business).fetch_top_urls
    response = leo_client.create_project(business.domain, CALLBACK_URL, nil, urls, business.total_pages_crawled)
    project_id = response.fetch('id', nil)
    break unless project_id
    business.update_attributes(leo_project_id: project_id)
    leo_api_datum = business.create_leo_api_datum
    leo_api_datum.update_attributes(project_id: project_id, last_crawl_created_at: Time.current)
  end
end
