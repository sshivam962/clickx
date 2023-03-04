class RemoveUnusedFieldsFromBusiness < ActiveRecord::Migration[5.1]
  def change
    remove_column :businesses, :campaign_id, :string

    remove_column :businesses, :ppc_iframe, :string
    remove_column :businesses, :retargeting_iframe, :string

    remove_column :businesses, :google_analytics_service, :boolean,
                  default: false
    remove_column :businesses, :search_console_service, :boolean, default: false

    remove_column :businesses, :website_service, :boolean, default: false
    remove_column :businesses, :website_url, :string

    remove_column :businesses, :fb_page, :string
    remove_column :businesses, :twitter_handle, :string
    remove_column :businesses, :google_plus_id, :string
    remove_column :businesses, :youtube_channel_id, :string

    remove_column :businesses, :fb_likes, :string, default: 0
    remove_column :businesses, :twitter_followers_count, :string, default: 0
    remove_column :businesses, :google_followers_count, :string, default: 0
    remove_column :businesses, :youtube_subscribers_count, :string, default: 0
    remove_column :businesses, :yesterdays_fb_likes, :string, default: 0
    remove_column :businesses, :yesterdays_twitter_followers, :string,
                  default: 0
    remove_column :businesses, :yesterdays_google_followers, :string, default: 0
    remove_column :businesses, :yesterdays_youtube_subscribers, :string,
                  default: 0

    remove_column :businesses, :adword_service, :boolean
    remove_column :businesses, :ppc_service, :boolean, default: false
    remove_column :businesses, :retargeting_service, :boolean, default: false
    remove_column :businesses, :display_service, :boolean
    remove_column :businesses, :video_service, :boolean, default: false
  end
end
