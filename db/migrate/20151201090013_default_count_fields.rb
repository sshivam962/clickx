class DefaultCountFields < ActiveRecord::Migration[4.2]
  def change
    change_column_default :businesses, :fb_likes, 0
    change_column_default :businesses, :yesterdays_fb_likes, 0

    change_column_default :businesses, :google_followers_count, 0
    change_column_default :businesses, :yesterdays_google_followers, 0

    change_column_default :businesses, :twitter_followers_count, 0
    change_column_default :businesses, :yesterdays_twitter_followers, 0

    change_column_default :businesses, :youtube_subscribers_count, 0
    change_column_default :businesses, :yesterdays_youtube_subscribers, 0
  end
end
