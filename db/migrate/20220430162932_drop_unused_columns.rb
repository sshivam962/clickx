class DropUnusedColumns < ActiveRecord::Migration[5.2]
  def up
    remove_columns :businesses, :adroll_service_enabled
    remove_columns :businesses, :automate_display_campaign
    remove_columns :businesses, :automate_video_campaign
    remove_columns :businesses, :lead_form_enabled
    remove_columns :businesses, :leads_service
    remove_columns :businesses, :live_chat_service
    remove_columns :businesses, :roadmap_service
    remove_columns :businesses, :show_facebook_profile
    remove_columns :businesses, :show_linkedin_profile
    remove_columns :businesses, :social_magnet_service
    remove_columns :businesses, :social_publishing_service
    remove_columns :businesses, :display_budget
    remove_columns :businesses, :display_cost_markup
    remove_columns :businesses, :video_budget
    remove_columns :businesses, :video_cost_markup
    remove_columns :businesses, :adroll_integration
    remove_columns :businesses, :display_campaign_ids
    remove_columns :businesses, :display_client_id
    remove_columns :businesses, :linkedin_access_secret
    remove_columns :businesses, :linkedin_access_token
    remove_columns :businesses, :selected_fb_pages
    remove_columns :businesses, :selected_linkedin_pages
    remove_columns :businesses, :tracker_id
    remove_columns :businesses, :twitter_access_secret
    remove_columns :businesses, :twitter_access_token
    remove_columns :businesses, :video_campaign_ids
    remove_columns :businesses, :video_client_id
  end

  def down
  end
end
