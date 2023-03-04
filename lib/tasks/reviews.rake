# frozen_string_literal: true

namespace :reviews do
  desc 'Update Reviews'
  task fetch_latest: :environment do
    Business.find_each(batch_size: 10) do |biz|
      biz.locations.each(&:fetch_latest_reviews)
    end
  end

  task remove_false: :environment do
    Review.where('timestamp > ?', Date.tomorrow).destroy_all
  end

  desc 'Send mail to business admin if there are new reviews on a daily basis'
  task send_daily_email: :environment do
    Business.find_each(batch_size: 10) do |biz|
      # avg_rating = biz.reviews.average(:rating).try(:round, 2).to_f
      # review_ids = biz.reviews.where('timestamp >= ?', Date.current).pluck(:id)
      review_ids = biz.reviews.where(timestamp: 24.hours.ago..Time.current).pluck(:id)
      next unless review_ids.count > 0
      email_ids = biz.users_with_email_preference(:reviews, :review_updates).collect(&:email)
      email_ids += User.admins_mailing_list.pluck(:email)
      email_ids.each do |email|
        Notifier.new_reviews_email(review_ids, email, biz.id).deliver_later
      end
    end
  end
end
