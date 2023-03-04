class AddSocialCountFieldsToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :google_plus_id,                 :string 
    add_column :businesses, :google_followers_count,         :integer

    add_column :businesses, :youtube_channel_id,             :string
    add_column :businesses, :youtube_subscribers_count,      :integer

    add_column :businesses, :yesterdays_fb_likes,            :integer
    add_column :businesses, :yesterdays_twitter_followers,   :integer
    add_column :businesses, :yesterdays_google_followers,    :integer
    add_column :businesses, :yesterdays_youtube_subscribers, :integer
  end
end
