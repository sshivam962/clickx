# frozen_string_literal: true

namespace :keywords do
  desc 'Fetch Keyword Difficulty'
  task update_kdi: :environment do
    # heroku doesn't allow weekly jobs hence adding comment for a specific day
    if false # Time.zone.now.sunday?
      keywords = Keyword.where('kdi_updated_at < ?', 1.year.ago)
      keywords.each(&:set_kdi)
    end
  end

  desc 'Update keywords monthly summary view'
  task update_keywords_monthly_summary: :environment do
    KeywordMonthlyRankingsView.refresh
  end

  desc 'Update keywords daily summary view'
  task update_keywords_daily_summary: :environment do
    KeywordDailyRankingsView.refresh
  end

  desc 'Fetch OneIMS Keywords'
  task oneims_daily_keywords_mail: :environment do
    @business = Business.find_by(id: 166)
    if @business
      @keywords = Businesses::KeywordRanks.fetch(@business, {sort: 'google_ranking_change', limit: 1000, offset: 0, sort_order: 'false', time_string: 'all_time', id: 166})
      KeywordsMailer.oneims_daily_mail(@business, @keywords).deliver_now
    end
  end
end
