# frozen_string_literal: true

namespace :backlinks do
  def fetch_backlink_history(biz, date)
    info = biz.backlink_histories.find_or_initialize_by(tracked_date: date)
    info.fetch_data(date) if info.persisted? && info.updatable?
    info.save
  rescue StandardError
  end

  desc 'Backlinks Info Updater'
  task update_info: :environment do
    date_range = 3.days.ago.to_date..1.day.ago.to_date
    @businesses = Business.where(backlink_service: true)

    date_range.each do |date|
      @businesses.find_each(batch_size: 10) do |biz|
        fetch_backlink_history(biz, date)
      end
    end
  end
end
