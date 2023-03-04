# frozen_string_literal: true
namespace :keyword_ranking do
  desc 'add rank to keywords for missing dates'
  task fill_missing_data: :environment do
    Business.without_semrush.with_keyword_ranking.find_each do |business|
      business.keywords.each do |keyword|
        oldest_ranking_data = keyword.keyword_rankings
                                     .where('created_at > ?', Date.current.beginning_of_year)
                                     .order('created_at asc').first
        start_date = oldest_ranking_data.rank_date if oldest_ranking_data
        next unless oldest_ranking_data

        (start_date..Date.current).each do |date|
          keyword.keyword_rankings.first_or_dup_on(rank_date: date).save
        end

        puts "Keyword: #{keyword.name} - done" if keyword
      end
      puts "Business: #{business.name} - done"
    end
  end

  task fill_missing_data_for_business: :environment do
    business = Business.without_semrush.with_keyword_ranking.find(ARGV[1])
    business.keywords.each do |keyword|
      oldest_ranking_data = keyword.keyword_rankings.order('created_at asc').first
      start_date = oldest_ranking_data.rank_date if oldest_ranking_data
      next unless oldest_ranking_data
      (start_date..Date.current).each do |date|
        rank = keyword.keyword_rankings.first_or_dup_on(rank_date: date)
        rank.save unless rank.id
      end
      puts "Keyword: #{keyword.keyword.name} - done"
    end
    puts "Business: #{business.name} - done"
    exit
  end

  desc 'Create the ranking for the day'
  task create_keyword_rankings: :environment do
    Business.without_semrush.with_keyword_ranking.find_each do |business|
      business.keywords.each do |keyword|
        ranking_for_today = keyword.keyword_rankings.first_or_dup_on(rank_date: Date.current.to_s)
        ranking_for_today.save
      end
    end
  end

  desc 'Check if the data is available'
  task fetch_rank: :environment do
    google_ranks = FailedKeywordRanks.get_failed_rank engine: 'google'
    google_ranks.each do |data|
      FetchRankCallbackJob.perform_async(nil, Date.today, data['name'], 'google', data['city'], data['locale'])
    end
  end

  desc 'Resend Keywords not updated after 12 hours'
  task fetch_failed_ranks: :environment do
    if Date.current.monday? || Date.current.thursday?
      google = FailedKeywordRanks.get_failed_rank engine: 'google'
      google.each do |keyword|
        AddToDelayedQueueJob.perform_async(keyword['name'], 'google', keyword['city'], 'keyword_ranking', keyword['locale'])
      end
    end
  rescue StandardError => e
    AdminMailer.failed_keyword('Failed to resubmit the keyword to AuthorityLabs', e.message).deliver_now
  end

  desc 'Send mail for unavailable keyword ranks'
  task send_mail_for_blank_keyword_ranks: :environment do
    if (Date.current.monday? || Date.current.thursday?)
      google = FailedKeywordRanks.get_failed_rank engine: 'google'
      csv_data = CSV.generate do |csv|
        csv << ['Name', 'Engine', 'Business name', 'Business ID']
        google.each do |keyword|
          csv << [keyword['name'], 'google', keyword['biz_name'], keyword['biz_id']]
        end
      end
      AdminMailer.empty_ranks_keyword(csv_data, google.count).deliver_now
    end
  rescue StandardError => e
    puts "Failed to deliver email \n#{e.message}"
    AdminMailer.failed_keyword('Failed to send email of failed keywords',
                               e.message).deliver_now
  end
end
