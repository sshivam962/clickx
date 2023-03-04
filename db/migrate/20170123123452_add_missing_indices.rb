class AddMissingIndices < ActiveRecord::Migration[4.2]
      def change
        add_index :activities, :business_id
        add_index :activities, :user_id
        add_index :tracker_visits, :tracker_website_id
        add_index :tracker_form_submissions, :visitor_id
        add_index :tracker_form_submissions, :form_id
        add_index :tracker_form_submissions, :tracker_website_id
        add_index :page_forms, :tracker_website_id
        add_index :subscriptions, :business_id
        add_index :social_posts, :business_id
        add_index :users, [:ownable_id, :ownable_type]
        add_index :reminder_emails, :business_id
        add_index :content_order_defaults, :business_id
        add_index :content_orders, :user_id
      end
end
