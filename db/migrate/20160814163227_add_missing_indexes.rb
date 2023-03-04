class AddMissingIndexes < ActiveRecord::Migration[4.2]
  def change
    add_index :tasks, :business_id
    add_index :state_trackers, :content_id
    add_index :state_trackers, :user_id
    add_index :users, [:invited_by_id, :invited_by_type]
    add_index :users, :business_id
    add_index :mail_templates, :user_id
    add_index :questions, :group_id
    add_index :keyword_rankings, :business_keyword_id
    add_index :email_preferences, :user_id
    add_index :comments, :content_id
    add_index :comments, :user_id
    add_index :backlink_data, :business_id
    add_index :ad_reports, :business_id
    add_index :answers, :questionnaire_id
    add_index :answers, :question_id
    add_index :businesses, :agency_id
    add_index :campaign_reports, :business_id
    add_index :competitions, :business_id
    add_index :contents, :business_id
    add_index :locations, :business_id
    add_index :logins, :business_id
    add_index :questionnaires, :business_id
    add_index :seo_rankings, :business_id
    add_index :site_audit_data, :business_id
    add_index :tokens, :business_id
  end
end
