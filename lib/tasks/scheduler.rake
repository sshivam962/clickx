# frozen_string_literal: true

desc 'Call heroku apps'
task call_page: :environment do
  call_app('https://app.clickx.io', true)
  call_app('https://clickx-staging.herokuapp.com', false)
end

def call_app(url, is_prod = false)
  require 'net/http'
  require 'net/https'
  uri = URI.parse(url)
  if is_prod
    http_connection = Net::HTTP.new(uri.host, 443)
    http_connection.use_ssl = true
    http_connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
  else
    http_connection = Net::HTTP.new(uri.host, 80)
  end
  http_connection.get(uri.request_uri)
end

namespace :seo_reports do
  desc 'Fetch Keywords Rank Changes'
  task fetch_keywords_ranking: :environment do
    if Date.current.monday? || Date.current.thursday?
      google_count = 0
      Keyword.joins(:business).where("businesses.deleted_at is null").where('businesses.keyword_ranking_service = ?', true).find_each do |keyword|
        next if keyword.business.agency_id == 67
        keyword.keyword_rankings.first_or_dup_on(rank_date: Date.current).save
        AddToDelayedQueueJob.perform_async(keyword.name, 'google', keyword.city, 'keyword_ranking', keyword.locale)
        google_count += 1
      end
      AdminMailer.initial_keyword_submition(
        google_count, Time.zone.now.strftime('%Y-%m-%d %I:%M %p')
      ).deliver_now
    end
  end

  desc 'Run task to get keywords of single business'
  task :fetch_keyword_ranking_for_business, [:business_id] => :environment do
    business = Business.with_keyword_ranking.find(args[:business_id].to_i)
    business.keyword.each do |keyword|
      AddToDelayedQueueJob.perform_async(keyword.name, 'google', keyword.city, 'keyword_ranking', keyword.locale)
    end
  end

  desc 'Update Search Volume and CPC'
  task update_sc_and_cpc: :environment do
    UpdateSvAndCpcJob.perform_async if Date.current.day == 1
  end
end

namespace :writer_access do
  desc 'Fetch data for dropdowns in writer access order form'
  task writer_form_update: :environment do
    WriterForm.new.save if WriterForm.all.count == 0
    WriterForm.weekly_update
  end
  desc 'Fetch order content from writer access'
  task fetch_order_content: :environment do
    ContentOrder.where(order_status: 2).each do |co|
      @data = WriterAccess.preview_order co.content_order_id
      next unless @data['orders']
      next unless @data['orders'][0]['id'] == co.content_order_id.to_i
      @content = Content.new
      @content.business_id = co.business_id
      @content.title = @data['orders'][0]['title']
                       .encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
      @content.content = @data['orders'][0]['text']
                         .encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
      next unless @content.save
      Notifier.content_order_approval(co).deliver_now
      co.order_status = 3
      co.save
    end
  end
end

namespace :reminder_mail do
  desc "Send mail to clients after 5 days of campaign
  creation to remind them to fill out the details"
  task fill_campaign_details: :environment do
    Business.where('created_at >= :date', date: 30.days.ago).each do |b|
      @update_intelligence = @update_location = false
      unless b.managed_ppc_service
        @update_location = b.locations.size.zero? if b.local_profile_service
      end
      @update_intelligence = b.questionnaire.blank? if b.managed_seo_service || b.managed_ppc_service
      next unless @update_location || @update_intelligence
      @reminder_email = b.reminder_email
      next unless (@reminder_email.last_email_sent_at.nil? && b.created_at < 5.days.ago) || (!@reminder_email.last_email_sent_at.nil? && @reminder_email.last_email_sent_at < 5.days.ago)
      Notifier.reminder_email_fill_campaign_data(b, @update_location, @update_intelligence).deliver_now
      @reminder_email.last_email_sent_at = Time.now
      @reminder_email.increment(:email_count)
      @reminder_email.save
    end
  end
end
namespace :agency_report do
  desc 'Send monthly report'
  task send_to_admin: :environment do
    Agency.find_each do |agency|
      next if agency.admins_with_email_preference('business_reports', 'business_performance_report').to_a.empty?
      Notifier.agency_report(agency).deliver_now
    end
  end
end

namespace :api_usage do
  desc 'SEMRush API Usage Stats'
  task semrush: :environment do
    require 'semrush'

    credit_balance = Semrush.api_credit_balance
    AdminMailer.semrush_credit_low(credit_balance).deliver_now
    # if credit_balance < 10_000_000
  end

  desc 'Authority Labs Balance Stats'
  task authority_labs: :environment do
    include AuthorityLabs

    balance = AuthorityLabs.current_balance
    AdminMailer.authority_labs_low_balance(balance).deliver_now if balance < 100
  end
end
