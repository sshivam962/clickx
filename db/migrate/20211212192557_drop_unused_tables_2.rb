class DropUnusedTables2 < ActiveRecord::Migration[5.1]
  def change
    drop_table :fb_lead_gen_form_submissions
    drop_table :fb_leadgen_subscriptions
    drop_table :fb_pages

    drop_table :social_magnet_templates
    drop_table :social_media
    drop_table :social_media_schedules
    drop_table :social_posts
    drop_table :social_snips
  end
end
