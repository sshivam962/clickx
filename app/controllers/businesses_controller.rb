# frozen_string_literal: true

class BusinessesController < ApplicationController
  include GoogleAnalytics
  include GoogleSearchConsole
  include Majestic
  include Marchex
  include DateUtils
  include Reportable

  layout 'report', only: :weekly_report_preview

  SORT_PARAMS = {
    'googleRanking' => 'google_rank',
    'searchVolume' => 'search_volume::int',
    'name' => 'keywords.name'
  }.freeze

  before_action :get_current_user
  before_action :check_if_system_super_admin, only: :force_delete
  before_action :check_if_super_admin, only: %i[
    destroy create update archived_list unarchive
    force_delete weekly_report_preview
  ]
  before_action :get_business, except: %i[
    create index
    get_total_labels
    reinitilize_labels_set adword_campaigns
    archived_list unarchive facebook_media
    get_fb_pages post_on_fb_page
    update_timezone get_site_ids
    force_delete get_business_report
    leo_audit_callback
    client_traction deleted_business_keywords
    ownable_businesses_list send_support_email
    update_keyword set_google_auth_paths
  ]

  skip_before_action :verify_authenticity_token, :authenticate_user!, only: [:leo_audit_callback]

  analytics_methods = %i[
    google_analytics
    google_search_analytics
    google_referral_analytics
    google_locale_analytics
    google_goal_analytics
    google_social_overview
    google_social_overview_urls
    google_social_network_referral
    google_social_landing
    google_landing_pages
    google_acquisition_campaigns
    google_source_medium
  ]

  analytics_methods.each do |method|
    before_action -> { stub_with_dummy_data(key: method) }, only: method
  end

  before_action -> { stub_with_dummy_data(key: :get_calls) }, only: :get_calls
  search_console_methods = %i[
    google_search_console_pages
    google_search_console
    crawl_errors
    crawl_errors_csv
    sitemaps
  ]

  search_console_methods.each do |page|
    before_action -> { stub_with_dummy_data(key: page) }, only: page
  end

  before_action :check_google_analytics_service,
                only: analytics_methods
  before_action :check_search_console_service,
                only: search_console_methods

  before_action :get_google_auth_client_analytics,
                only: analytics_methods
  before_action :get_google_auth_client_search_console,
                only: search_console_methods

  before_action :ga_dates, only: (analytics_methods + search_console_methods)
  %i[
    backlinks backlinks_summary
    top_pages anchor_text backlinks_history
    anchor_text_page anchor_text_word_cloud topics
    ref_domains
  ].each do |page|
    before_action -> { stub_with_dummy_data(key: page) }, only: page
  end

  before_action :build_backlink_datum, only: %i[backlinks backlinks_summary
                                                top_pages anchor_text]

  before_action -> { stub_with_dummy_data(key: 'business_keywords') }, only: :business_keywords
  before_action -> { stub_with_dummy_data(key: 'get_datewise_rankings') }, only: :get_datewise_rankings
  before_action -> { stub_with_dummy_data(key: 'rank_summaries') }, only: :rank_summaries

  before_action :latest_keyword_ranking,
                only: %i[export_kr_to_csv business_keywords]

  before_action :build_backlink_datum, only: %i[
    backlinks backlinks_summary
    top_pages anchor_text
  ]

  before_action -> { stub_with_dummy_data(key: 'marketing_performance') }, only: :marketing_performance
  before_action :marketing_performance_dates, only: :marketing_performance
  before_action :set_current_user_for_business, only: %i[
    update
    save_adword_campaign_ids
  ]

  before_action :export_disabled?, only: %i[export_kr_to_csv
                                            export_kr_to_pdf]
  before_action -> { authorize :businesses, :visible? }, only: %i[
    index edit archived_list
  ]
  before_action -> { authorize :businesses, :manage? }, only: %i[
    create destroy update unarchive
  ]
  before_action -> { authorize @business, :visible? }, except: %i[
    create index edit
    get_total_labels keywords_list
    reinitilize_labels_set adword_campaigns
    archived_list unarchive facebook_media
    get_fb_pages post_on_fb_page
    update_timezone get_site_ids
    force_delete get_business_report
    leo_audit_callback
    client_traction deleted_business_keywords
    destroy update ownable_businesses_list
    send_support_email update_keyword set_google_auth_paths
  ]

  after_action :create_onboarding_procedures, only: :update

  def index
    render json: BusinessesQuery.new(params: params).index_view
  end

  def ownable_businesses_list
    render json: original_user.ownable_businesses
  end

  def archived_list
    @businesses = Business.only_deleted.search_by_name(params[:search]).paginate(page: params[:page], per_page: 20)
    render json: { businesses: @businesses, page: @businesses.current_page, total_items: @businesses.total_entries, per_page: @businesses.per_page }
  end

  def unarchive
    @business = Business.only_deleted.find(params[:id])
    authorize @business, :manage?
    if @business
      @business.restore
      render json: Business.only_deleted.to_json
    else
      render json: { status: 406,
                     errors: 'Business not found' }
    end
  end

  def force_delete
    @business = Business.only_deleted.find(params[:id])
    authorize @business, :system_super_admin_action?
    if @business.really_destroy!
      render json: Business.only_deleted.to_json
    else
      render json: { status: 406,
                     errors: 'Business not found' }
    end
  end

  def show
    render json: @business.to_json
  end

  def all_info
    render json: @business.as_json(all_info: true)
  end

  def edit
    render json: @business.to_json
  end

  def create
    @business = Business.new(business_params)
    if @business.save
      start_crawl_in_leo
      render json: { status: 201,
                     business: @business }
    else
      render json: { status: 406,
                     business: @business,
                     errors: @business.errors.full_messages }
    end
  end

  def update
    if @business.update_attributes(business_params)
      render json: { status: 200,
                     business: @business }
    else
      render json: { status: 406,
                     business: @business,
                     errors: @business.errors }
    end
  end

  def google_analytics_visits(start_date, end_date)
    get_google_auth_client_analytics
    direct_visit_count(@auth_google_client, @business.google_analytics_id,
                       start_date.to_s, end_date.to_s)
  end

  def marketing_data(start_date, end_date)
    data = {}
    inc_visits = 0
    get_visits = google_analytics_visits(start_date, end_date)

    start_date.upto(end_date) do |date|
      visit = get_visits[date.to_s.tr('-', '')].to_i
      inc_visits += visit
      data[date.to_s] = { visit: inc_visits }
    end
    data['total_counts'] = { visits: inc_visits }
    data
  end

  def marketing_performance
    st_date = @start_date.to_date
    end_date = @end_date.to_date
    st_last_date = @start_last_period.to_date
    end_last_date = @end_last_period.to_date
    this_period = marketing_data(@start_date.to_date, @end_date.to_date)
    last_period = marketing_data(@start_last_period.to_date, @end_last_period.to_date)
    this_period_time = end_date - st_date
    last_period_time = end_last_date - st_last_date
    if this_period_time.to_i < last_period_time.to_i
      begin_date = end_date.to_date + 1.day
      gap = last_period_time - this_period_time
      last_date = begin_date + gap.to_i.days - 1.day
      (begin_date..last_date).each do |day|
        this_period.merge!(day.to_s => { visit: nil, contact: nil, customer: nil })
      end
    elsif this_period_time.to_i > last_period_time.to_i
      begin_date = end_last_date.to_date + 1.day
      gap =  this_period_time - last_period_time
      last_date = begin_date + gap.to_i.days
      (begin_date..last_date).each do |day|
        last_period.merge!(day.to_s => { visit: nil, contact: nil, customer: nil })
      end
    end

    this_period_total_visits = this_period['total_counts'][:visits]

    this_period_total_contacts = this_period['total_counts'][:contacts]
    this_period_total_customers = this_period['total_counts'][:customers]
    last_period_total_visits = last_period['total_counts'][:visits]
    last_period_total_contacts = last_period['total_counts'][:contacts]
    last_period_total_customers = last_period['total_counts'][:customers]
    unless this_period_total_visits.zero?
      visit_percent = ((this_period_total_visits - last_period_total_visits) /
                        this_period_total_visits.to_f) * 100
    end
    unless this_period_total_contacts.zero?
      contact_pecent = ((this_period_total_contacts - last_period_total_contacts) /
                         this_period_total_contacts.to_f) * 100
    end
    unless this_period_total_customers.zero?
      customer_percent = ((this_period_total_customers - last_period_total_customers) /
                           this_period_total_customers.to_f) * 100
    end
    visit_to_contact_percentage = (this_period_total_contacts + 0.0) * 100 / this_period_total_visits
    contact_to_customers_percentage =
      begin
        (this_period_total_customers + 0.0) * 100 / this_period_total_contacts
      rescue ZeroDivisionError
        0
      end
    contact_to_customers_percentage = 0 unless contact_to_customers_percentage.finite?
    data = { this_period: this_period,
             last_period: last_period,
             visit_percent: visit_percent,
             contact_pecent: contact_pecent || 0,
             customer_percent: customer_percent || 0,
             visit_to_contact_percentage: visit_to_contact_percentage,
             contact_to_customers_percentage: contact_to_customers_percentage }
    render json: { status: 200, data: data }
  end

  def keyword_rank_history
    @rankings = Keywords::RankHistory.new(params, @business).fetch
    keyword_name = Keyword.find(params[:keyword_id]).name
    competitors_rank = Keywords::CompetitorsRank.new(keyword_name, @business).fetch
    respond_to do |format|
      format.json do
        render json: { status: 200, data: @rankings.as_json(skip: true),
                       keyword_name: keyword_name, competitors_rank: competitors_rank }
      end
      format.csv { send_data @rankings.to_csv }
    end
  rescue Exception
    head :not_found
  end

  def destroy
    deleted_business_params = [@business.id, @business.name, @business.locale]
    if @business.update(deleted_at: Time.current)
      BusinessOnDeleteSendDetailsJob.perform_async(*deleted_business_params)
      render json: { status: 200 }
    else
      render json: { status: 406,
                     business: @business,
                     errors: @business.errors }
    end
  end

  def business_users
    render json: @business.users
  end

  def activity_list
    page = params[:page] or 1
    per_page = params[:per_page] or 10

    @activities = @business.activities.includes(:user)
                           .order(created_at: :desc)
                           .paginate(page: page, per_page: per_page)
    render json: {
      data: @activities,
      page: page.to_i,
      total_entries: @activities.total_entries,
      per_page: per_page.to_i
    }
  end

  def update_logo
    if @business.update_attributes(business_logo_params)
      render json: { status: 200,
                     business: @business }
    else
      render json: { status: 406,
                     business: @business,
                     errors: @business.errors }
    end
  end

  def update_timezone
    # eg params : timezone: "Central Time (US & Canada)"
    @business = current_business
    authorize @business, :manage?
    if @business.update_attributes(timezone: params[:timezone])
      render json: { status: 200,
                     business: @business }
    else
      render json: { status: 406,
                     business: @business,
                     errors: @business.errors }
    end
  end

  def add_to_keyword_bank
    @errors = []
    if tag_params[:tags].present?
      @tags = Keywords::CreateTag.new(@business.id, tag_params[:tags]).run
    end
    city = params[:city]&.downcase
    locale = params[:locale]
    params[:keyword]&.delete_if(&:blank?).each do |name|
      if @business.keywords.active.count >= @business.keyword_limit
        @errors.push(
          'Keyword Limit Exceeded, Delete Keywords or Upgrade your plan.'
        )
        break
      end
      deleted_keyword =
        @business.keywords.only_deleted.find_by(
          name: normalize(name), locale: locale, city: city
        )
      keyword =
        if deleted_keyword.present?
          deleted_keyword.restore
        else
          Keyword.create(
            name: name, locale: locale, city: city, business: @business
          )
        end
      tag_keywords(keyword, @tags) if @tags.present? && keyword.errors.blank?
      next if keyword.errors.blank?

      @errors.push(
        keyword.errors.full_messages.to_sentence.gsub('Name', keyword.name)
      )
    end
    if @errors.present?
      render json: { status: 406, business: @business, error: @errors.join(', ')}
    else
      render json: { status: 201, business: @business, errors: @business.errors }
    end
  end

  def get_total_labels
    tags = Business.label_counts.pluck(:name)
    total_labels = ActsAsTaggableOn::Tag.where(taggings_count: 0).pluck(:name) + tags
    render json: { total_label_list: total_labels }
  end

  def set_budget
    @business.update_attributes(budget_params)
    render json: { status: 200, data: @business, message: 'Budget saved successfully' }
  end

  def reinitilize_labels_set
    authorize :businesses, :visible?
    label_set = MultiJson.load(params[:label_names])
    ActsAsTaggableOn::Tag.find_or_create_all_with_like_by_name(label_set['names'])
    ActsAsTaggableOn::Tag.where.not(name: label_set['names']).destroy_all
    render json: { status: 200,
                   total_label_list: ActsAsTaggableOn::Tag.all.pluck(:name) }
  end

  def get_calls
    data = Rails.cache.fetch("marchex_calls_#{@business.id}_#{params[:start]}_#{params[:end]}", expires_in: 24.hours) do
      Marchex.calls(
        start_date: params[:start],
        end_date: params[:end],
        call_analytics_id: @business.call_analytics_id
      )
    end
    @data = data.map { |analytics_data| CallAnalyticsPresenter.new(analytics_data) }
    respond_to do |format|
      format.pdf do
        render pdf: 'CallAnalyticsData.pdf',
               print_media_type: true
      end
      format.json do
        render json: { status: 200, business: @business, calls: data }
      end
    end
  rescue Marchex::Error
    render json: { error: 'Unable to fetch the details' }, status: :not_found
  end

  def get_call_details
    data = call_marchex_api([params[:call_id]], 'call.get')
    render json: { call_details: data }
  end

  def get_call_audio
    data = call_marchex_api([[params[:call_id]], 'mp3'], 'call.audio.url')
    render json: { call_audio: data.first['url'] }
  end

  def save_adword_campaign_ids
    adword_campaign_ids =
      if params[:automated]
        adword_campaign_ids_for_automated
      else
        params[:adword_campaign_ids]
      end
    if @business.update_attributes(automate_adword_campaign: params[:automated], adword_campaign_ids: adword_campaign_ids)
      render json: { status: 200, business: @business, message: 'Success' }
    else
      render json: { code: 406, data: @business,
                     message: @business.errors.full_messages.to_sentence }
    end
  end

  def google_analytics
    get_google_data('get_google_api_data')
  end

  def google_search_analytics
    get_google_data('get_google_search_api_data')
  end

  def google_referral_analytics
    get_google_data('get_referral_data')
  end

  def google_locale_analytics
    get_google_data('get_locale_data')
  end

  def google_goal_analytics
    get_google_data('get_goal_data')
  end

  def google_social_overview
    get_google_data('get_google_social_overview')
  end

  def google_social_overview_urls
    get_google_data('get_google_social_overview_urls')
  end

  def google_social_network_referral
    get_google_data('get_google_social_network_referral')
  end

  def google_social_landing
    get_google_data('get_google_social_landings')
  end

  def google_landing_pages
    get_google_data('get_google_landing_pages')
  end

  def google_acquisition_campaigns
    get_google_data('get_campaigns_data')
  end

  # def google_source_medium
  #   render json: {
  #     data: GoogleAnalytics::SourceMedium.new(
  #       @start_date, @end_date, @auth_google_client,
  #       @business.google_analytics_id, params
  #     ).get_campaigns_data,
  #     status: 200
  #   }
  # end

  def ga_dates
    @start_date = params[:start_date] || (Date.today - 30.days).strftime('%Y-%m-%d')
    @end_date = params[:end_date] || Date.today.strftime('%Y-%m-%d')
  end

  def marketing_performance_dates
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    if params[:date_range] == 'custom_date_range'
      difference = (Date.parse(@end_date) - Date.parse(@start_date)).to_i + 1
      @start_last_period = (Date.parse(@start_date) - difference.days).strftime('%Y-%m-%d')
      @end_last_period = (Date.parse(@start_date) - 1.day).strftime('%Y-%m-%d')
    else
      @start_last_period = start_date_from_date_string(params[:date_range], true)
      @end_last_period = end_date_from_date_string(params[:date_range], true)
    end
    render json: { message: 'Invalid date' } unless @start_date && @end_date && @start_last_period && @end_last_period
  end

  def get_google_data(method)
    method_to_class = {
      get_google_api_data: GoogleAnalytics::Overview,
      get_google_search_api_data: GoogleAnalytics::SearchesData,
      get_google_landing_pages: GoogleAnalytics::LandingPages,
      get_referral_data: GoogleAnalytics::Referrals,
      get_goal_data: GoogleAnalytics::Goals,
      get_google_social_network_referral: GoogleAnalytics::SocialReferrals,
      get_campaigns_data: GoogleAnalytics::Campaigns,
      get_locale_data: GoogleAnalytics::Locales
    }
    fetcher = method_to_class.fetch(method.to_sym, nil)
    begin
      google_data =
        if fetcher
          fetcher.new(@business, params).fetch
        else
          send(method, @auth_google_client, @business.google_analytics_id, @start_date, @end_date)
        end
      resp = { status: 200, data: google_data }
      render json: resp and return
    rescue StandardError => e
      logger.info "[Google Analytics] #{e.message} : #{e.backtrace}"
      render json: { status: 406, business: @business,
                     errors: "Error in fetching google analytics data. #{e.message}" } and return
    end
  end

  def get_business_report
    authorize :businesses, :visible?
    data = {}
    data['row'] = []
    Business.find_each(batch_size: 10) do |business|
      @crawled_pages = business.site_audit_service ? business.total_pages_crawled : 0
      data['row'] << { 'id' => business.id,
                       'name' => business.name,
                       'locations_count' => business.locations.size,
                       'keyword_limit' => business.keyword_limit,
                       'keywords_count' => business.keywords.size,
                       'crawled_pages' => @crawled_pages,
                       'target_city' => business.target_city }
    end
    render json: { status: 200, data: data }
  end

  def google_search_console
    get_google_search_console_data('get_search_console_overview')
  end

  def google_search_console_pages
    get_google_search_console_data('get_search_console_pages')
  end

  def get_google_search_console_data(method)
    @google_data = send(method, @auth_google_client, @start_date, @end_date, @business.site_url)
    respond_to do |format|
      format.pdf do
        render pdf: 'search_console_export.pdf'
      end
      format.json do
        render json: { status: 200, data: @google_data,
                       site_url: @business.site_url }
      end
    end and return
  rescue StandardError => e
    Rails.logger.info 'GOOGLE ANALYTICS'
    Rails.logger.info "#{e.message} #{e.backtrace}"
    render json: { status: 406, business: @business,
                   errors: 'Error in fetching Search Console data.' } and return
  end

  def crawl_errors
    if params[:client_type] && params[:client_type] == 'count only'
      method = 'get_crawl_errors_counts'
      error_type = client_type = nil
    else
      client_type = params[:client_type] || 'web'
      method = 'get_crawl_errors'
      error_type = params[:error_type] || 'serverError'
    end

    google_data = send(method, @auth_google_client, @business.site_url, client_type, error_type)
    render json: { status: 200, data: google_data, site_url: @business.site_url } and return
  rescue StandardError => e
    Rails.logger.info 'GOOGLE ANALYTICS'
    Rails.logger.info "#{e.message} #{e.backtrace}"
    render json: { status: 406, business: @business,
                   errors: 'Error in fetching google analytics data.' } and return
  end

  def crawl_errors_csv
    google_data = send('get_crawl_errors_for_csv', @auth_google_client, @business.site_url)
    url = @business.site_url.split('//').last
    send_data(google_data,
              type: 'text/csv; charset=utf-8; header=present',
              disposition: 'attachment',
              filename: "#{url}_#{Time.now.strftime('%Y%m%d%H%M%S')}_CrawlErrors.csv") and return
  rescue StandardError => e
    Rails.logger.info 'GOOGLE ANALYTICS'
    Rails.logger.info "#{e.message} #{e.backtrace}"
    flash[:warning] = ' Error in fetching google analytics data.'
    redirect_to root_url and return
  end

  def backlinks
    if @business.backlink_service
      updated_at = @business.backlink_datum.backlinks_updated_at
      if updated_at.blank? || updated_at < 7.days.ago
        response = get_backlinks(@business.domain)
        @business.backlink_datum
                 .update_attributes(backlinks: response,
                                    backlinks_updated_at: Time.now)
      end
      @backlinks = @business.backlink_datum.backlinks.map { |backlinks| BacklinksPresenter.new(backlinks) }
      respond_to do |format|
        format.pdf do
          render pdf: "backlinks.pdf",
                 print_media_type: true
        end
        format.json do
          render json: { status: 200, data: @business.backlink_datum.backlinks }
        end
      end
    else
      render json: { status: 406, business: @business,
                     errors: 'Business not yet opted for backlinks.' }
    end
  rescue StandardError
    render json: { status: 406, business: @business,
                   errors: 'Error in fetching backlinks' } and return
  end

  def backlinks_history
    if @business.backlink_service
      @backlinks_histories =
        @business.backlink_histories
                 .select(:tracked_date, :gained, :lost, :business_id)
                 .order(:tracked_date)
      render json: { status: 200, backlinks_history: @backlinks_histories }
    else
      render json: { status: 406, business: @business,
                     errors: 'Business not yet opted for backlinks.' }
    end
  rescue StandardError
    render json: { status: 406, business: @business,
                   errors: 'Error in fetching backlinks' } and return
  end

  def new_backlinks
    if @business.backlink_service
      date = params[:tracked_date]&.to_date
      count = params[:count] || 100

      backlinks = Majestic.new_backlinks(@business.host, date, date, count).dig(:data)
      render json: { status: 200, data: backlinks }
    else
      render json: { status: 406, business: @business,
                     errors: 'Business not yet opted for backlinks.' }
    end
  end

  def lost_backlinks
    if @business.backlink_service
      date = params[:tracked_date]&.to_date
      count = params[:count] || 100

      backlinks = Majestic.lost_backlinks(@business.host, date, date, count).dig(:data)
      render json: { status: 200, data: backlinks }
    else
      render json: { status: 406, business: @business,
                     errors: 'Business not yet opted for backlinks.' }
    end
  end

  def reviews_stars
    zero_star = one_star = two_star = three_star = four_star = five_star = 0
    @business.locations.each do |loc|
      loc.reviews.each do |rev|
        case rev.rating
        when 0 then zero_star += 1
        when 1 then one_star += 1
        when 2 then two_star += 1
        when 3 then three_star += 1
        when 4 then four_star += 1
        when 5 then five_star += 1
        end
      end
    end
    data = { '0star' => zero_star, '1star' => one_star, '2star' => two_star,
             '3star' => three_star, '4star' => four_star, '5star' => five_star }
    render json: { status: 200, data: data }
  end

  def backlinks_summary
    if @business.backlink_service
      updated_at = @business.backlink_datum.summary_updated_at if @business.backlink_datum
      begin
        if updated_at.blank? || updated_at < 7.days.ago
          response = get_backlink_summary(@business.domain)
          @business.backlink_datum.update_attributes(summary: response,
                                                     summary_updated_at: Time.now)
          render json: { status: 200, data: @business.backlink_datum.summary } and return
        else
          render json: { status: 200, data: @business.backlink_datum.summary } and return
        end
      rescue StandardError
        render json: { status: 406, business: @business,
                       errors: 'Error in fetching backlinks summary.' } and return
      end
    else
      render json: { status: 406, business: @business,
                     errors: 'Business not yet opted for backlinks.' } and return
    end
  end

  def anchor_text
    if @business.backlink_service
      updated_at = @business.backlink_datum.anchor_chart_data_updated_at
      begin
        if updated_at.blank? || updated_at < 7.days.ago
          response = get_anchor_text_chart_data(@business.domain)
          @business.backlink_datum.update_attributes(anchor_chart_data: response,
                                                     anchor_chart_data_updated_at: Time.now)
          render json: { status: 200, data: @business.backlink_datum.anchor_chart_data } and return
        else
          render json: { status: 200, data: @business.backlink_datum.anchor_chart_data } and return
        end
      rescue StandardError
        render json: { status: 406, business: @business,
                       errors: 'Error in fetching anchor text' } and return
      end
    else
      render json: { status: 406, business: @business,
                     errors: 'Business not yet opted for backlinks.' } and return
    end
  end

  def anchor_text_word_cloud
    if @business.backlink_service
      updated_at = @business.backlink_datum.anchor_word_cloud_updated_at
      begin
        if updated_at.blank? || updated_at < 7.days.ago
          response = get_word_cloud_data(@business.domain)
          @business.backlink_datum.update_attributes(anchor_word_cloud: response,
                                                     anchor_word_cloud_updated_at: Time.now)
          render json: { status: 200, data: @business.backlink_datum.anchor_word_cloud } and return
        else
          render json: { status: 200, data: @business.backlink_datum.anchor_word_cloud } and return
        end
      rescue StandardError
        render json: { status: 406, business: @business,
                       errors: 'Error in fetching anchor text' } and return
      end
    else
      render json: { status: 406, business: @business,
                     errors: 'Business not yet opted for backlinks.' } and return
    end
  end

  def leo_audit_callback
    Rails.logger.info "[Leo CALLBACK]: #{params}"
    if params['processed'] == 'true'
      SiteAuditCallbackJob.perform_async(params['project_id'], params['page_id'])
      head :ok
    elsif params['status'] == 'crawling_completed'
      LeoApiCallbackJob.perform_async(params['project_id'])
    else
      head :not_found
    end
  end

  def sitemaps
    google_data = send('get_sitemaps', @auth_google_client, @business.site_url)
    render json: { status: 200, data: google_data, site_url: @business.site_url } and return
  rescue StandardError
    render json: { status: 406, business: @business,
                   errors: 'Error in fetching google analytics data.' } and return
  end

  def clear_yext_cache
    @locations = @business.locations.where.not(yext_store_id: EMPTY)
    @locations.update_all(yext_listings: {})
    render json: { status: 200 }
  end

  def set_google_auth_paths
    render json: {
      status: 200,
      analytics_auth_path: get_google_auth_uri(Token::AnalyticsAccessToken),
      search_console_auth_path: get_google_auth_uri(Token::SearchConsoleAccessToken)
    }
  end

  def google_analytics_settings_change
    redirect_to get_google_auth_uri(Token::AnalyticsAccessToken)
  end

  def google_search_console_settings_change
    redirect_to get_google_auth_uri(Token::SearchConsoleAccessToken)
  end

  def business_keywords
    if current_user.normal?
      @business.update(keywords_last_viewed_at: Time.current)
    end
    keyword_limit = @business.keyword_limit
    render json: { status: 200, data: @results, keyword_limit: keyword_limit,
                   total_size: @business.keywords.count }
  end

  def competitor_ranks
    @business = Business.find(params[:id])
    competitor_ranks = Keywords::CompetitorsRank.new(params['keyword_name'], @business).fetch
    render json: {
      status: 200, competitor_ranks: competitor_ranks, message: ''
    }
  end

  def export_kr_to_csv
    csv_data = CSV.generate do |csv|
      csv << @latest_data.first.keys
      @latest_data.each do |data|
        csv << data.values
      end
    end
    send_data csv_data, disposition: 'attachment', filename: "KeywordRanking_#{Time.now.strftime('%Y%m%d')}.csv"
  end

  def export_kr_to_pdf
    html = render_to_string(action: :business_keywords)
    pdf = WickedPdf.new.pdf_from_string(html)
    send_data(pdf,
              filename: 'my_pdf_name.pdf',
              disposition: 'attachment')
  end

  def delete_business_keyword
    keywords = Keyword.where(id: params[:keyword_ids])
    if keywords.destroy_all
      Keyword.only_deleted
             .where(id: params[:keyword_ids])
             .update(keyword_tag_id: nil)
      render json: { status: 200 }
    else
      render json: { status: 406,
                     errors: @keywords.errors }
    end
  end

  def deleted_business_keywords
    data = []
    keywords = current_business.deleted_keywords.select('name', 'keywords.deleted_at', 'keywords.deleted_by')
    keywords.each do |keyword|
      deleted_user = User.find_by(id: keyword.deleted_by) || User.new(first_name: 'Unknown')
      data << { name: keyword.name,
                deleted_by: "#{deleted_user.try(:first_name)} #{deleted_user.try(:last_name)}",
                deleted_time: keyword.deleted_at }
    end
    data = data.group_by { |temp| temp[:deleted_time].strftime("%A #{temp[:deleted_time].day.ordinalize} %B %Y") }
    data.map do |d|
      d[1].map do |v|
        v[:deleted_time] = v[:deleted_time].strftime('%I:%M %p')
      end
    end
    render json: data
  end

  def update_keyword
    @keyword = Keyword.find(params[:id])
    @keyword.update_attributes(keyword_params)
    render json: { status: 200, data: @keyword, message: 'Keyword updated successfully' }
  end

  # fetch ranking details from KeywordRanking Table.

  def get_datewise_rankings
    date_string = if params[:date_string].to_s.empty?
                    'all_time'
                  else
                    params[:date_string]
                  end
    data = KeywordRanking.send("#{date_string}_data", @business)
    render json: data.to_json
  end

  # keywords list for checking
  def keywords_list
    # authorize :businesses, :visible?
    render json: @business.keywords.select('keywords.id, keywords.name AS name')
  end

  def keyword_suggestions
    suggested_keywords =
      KeywordPlanner.related_keywords params[:queried_keyword]
    if suggested_keywords.present?
      render json: { status: 200,
                     data: suggested_keywords }
    else
      render json: { status: 406,
                     erros: 'Failed to get data from Semrush' }
    end
  end

  def get_site_ids
    render json: SITE_IDS
  end

  def client_traction
    authorize :businesses, :visible?
    @client_traction_count = Business.unscoped.unarchived.group_by_month(:created_at, format: '%b %Y').count
    counts = @client_traction_count.values
    counts.to_enum.with_index.map { |y, z| z > 0 ? counts[z] += counts[z - 1] : y }

    @free_client_traction_count = Business.unscoped.free.unarchived.group_by_month('businesses.created_at', format: '%b %Y').count
    free_counts = @free_client_traction_count.values
    free_counts.to_enum.with_index.map { |y, z| z > 0 ? free_counts[z] += free_counts[z - 1] : y }

    render json: {
      status: 200, data: {
        normal: {
          months: @client_traction_count.keys, count: counts
        },
        free: {
          months: @free_client_traction_count.keys, count: free_counts
        }
      }
    }
  end

  def agency_email_settings
    @agency = Agency.find(params[:agency_id])
    authorize @agency, :manage?
    @business = @agency.businesses.find(params[:id])
    @agency_admin = current_user
    render :agency_email_settings, layout: 'aa_themeX_base'
  end

  def update_business
    if @business.update_attributes(business_update_params)
      render json: { status: 200,
                     business: @business }
    else
      render json: { status: 406,
                     business: @business,
                     errors: @business.errors.full_messages }
    end
  end

  def add_domain
    if @business.update_attributes(domain: params[:domain])
      render json: { status: 200, website: @business.domain }
    else
      render json: { status: 406, errors: @business.errors }
    end
  end

  def wishlist_keywords
    render json: { keywords: @business.keywords.wishlist }
  end

  def send_support_email
    Notifier.business_support_mail(
      current_user,
      current_agency.from_email,
      current_agency,
      params[:content]
    ).deliver_now

    render json: { status: 200 }
  end

  def locations
    @business = Business.find(params[:id])
    @locations = @business.locations.select(:id, :name, :yext_store_id)
    render json: { locations: @locations.to_json(for_yext_store: true) }
  end

  def weekly_report_preview
    fetch_weekly_report(params)
    @agency = @business.agency
    @email_logo = @business.agency_email_logo
    if request.xhr?
      html = render_to_string template: 'notifier/weekly_mailer', layout: false
      render json: { status: 200, data: html}
    else
      render 'notifier/weekly_mailer'
    end
  end

  private

  def budget_params
    params.require(:budget).permit(:ppc_budget, :fb_budget)
  end

  def get_google_auth_client_analytics
    @auth_google_client = auth_google_client(@business, Token::AnalyticsAccessToken)
  end

  def get_google_auth_client_search_console
    @auth_google_client = auth_google_client(@business, Token::SearchConsoleAccessToken)
  end

  def business_logo_params
    params.require(:business).permit(:id, :logo)
  end

  def get_business
    # request.env is used to resolve an open issue of callback_url in omniauth-facebook gem
    @business = @current_business = Business.with_dummy.find(params[:id] || (request.env['omniauth.params'] && request.env['omniauth.params']['id']))
  end

  def business_params
    if params[:business]
      to_be_removed = %w[support_email update_at remaining_days
                         users locations collapsed unique_id updated_at]
      params[:business].delete_if { |k, _v| k.in?(to_be_removed) }
    end

    params.require(:business).permit(
      :id, :name, :agency_id, :local_profile_service, :seo_service,
      :keyword_limit, :site_audit_service, :call_analytics_service,
      :call_analytics_id, :google_analytics_id,
      :contents_service, :trial_service, :trial_expiry_date,
      :competitors_service,
      :site_url, :adword_client_id, :adword_cost_markup, :free_service,
      :bright_local_report_id, :target_city, :backlink_service, :domain,
      :total_pages_crawled, :logo, :managed_seo_service, :managed_ppc_service,
      :competitors_limit, :timezone, :chart_type, :fb_ad_account_id, :reputation_service, :custom_plan_id,
      :locale,
      label_list: [], adword_campaign_ids: []
    )
  end

  def business_update_params
    # params that are updatable by business admin
    params.require(:business).permit(
      :adword_client_id,
      :callrail_id, :callrail_account_id, :callrail_company_id,
      :locale, :timezone, :target_city,
      contact_mailing_list: []
    )
  end

  def tag_keywords(keyword, tags)
    keyword.keyword_tags = tags
    keyword.save
  end

  def tag_params
    params.permit(tags: %i[name color id])
  end

  def build_backlink_datum
    unless @business.backlink_datum
      @business.build_backlink_datum
      @business.backlink_datum
               .update_attributes(backlinks_updated_at: 10.days.ago,
                                  summary_updated_at: 10.days.ago,
                                  anchor_text_updated_at: 10.days.ago,
                                  topics_updated_at: 10.days.ago,
                                  pages_updated_at: 10.days.ago,
                                  ref_domains_updated_at: 10.days.ago,
                                  anchor_chart_data_updated_at: 10.days.ago,
                                  anchor_word_cloud_updated_at: 10.days.ago)
    end
  end

  def check_if_system_super_admin
    render json: { errors: 'Access denied' }, status: :not_acceptable and return unless current_user.super_admin? && current_user.clickx_admin?
  end

  def latest_keyword_ranking
    params[:limit] = params[:limit] || @business.keywords.count
    @latest_data = Businesses::KeywordRanks.fetch(@business, params)
    @count = @latest_data.count
    @results = @latest_data
  end

  def converted_time(time:)
    time.to_datetime
        .strftime('%a, %d %b %Y %H:%M:%S')
        .in_time_zone(current_business.timezone)
  end

  def set_current_user_for_business
    @business.current_user = current_user
  end

  def check_google_analytics_service
    unless @business.google_analytics_service?
      render json: {
        status: 406, business: @business,
        errors: 'Please connect your Google Analytics account.'
      } and return
    end
  end

  def check_search_console_service
    unless @business.search_console_service?
      render json: {
        status: 406, business: @business,
        errors: 'Please connect your Google Search Console account.'
      } and return
    end
  end

  def start_crawl_in_leo
    StartCrawlJob.perform_async(@business.id) if @business.site_audit_service?
  end

  def create_onboarding_procedures
    return unless params[:business][:onboarding_procedures]
    current_business
      .onboarding_procedures
      .where.not(id: params[:business][:onboarding_procedures].pluck(:id))
      .destroy_all
    params[:business][:onboarding_procedures].each do |procedure|
      procedure = OnboardingProcedure.find procedure['id']
      next if procedure['business_id'].present?

      procedure_copy = procedure.amoeba_dup
      procedure_copy.business = current_business
      procedure_copy.save
    end
  end

  def keyword_params
    params.require(:keyword).permit(:locale, :city)
  end

  def normalize(text)
    text.tr!('+', '')
    text.strip!
    text.downcase!
    text.squish!
    text.encode("UTF-8")
  end

  def adword_campaign_ids_for_automated
    adword_data = Adwords::Adword.new(
      current_business, current_business.adword_client_id, 'adword'
    ).campaigns
    adword_data.pluck(:id)
  end
end
