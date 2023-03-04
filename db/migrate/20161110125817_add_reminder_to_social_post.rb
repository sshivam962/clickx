class AddReminderToSocialPost < ActiveRecord::Migration[4.2]
  def change
  	add_column :social_posts, :reminder, :boolean, :default => false
  end
end
