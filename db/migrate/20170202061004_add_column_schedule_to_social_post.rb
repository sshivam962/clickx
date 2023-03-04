class AddColumnScheduleToSocialPost < ActiveRecord::Migration[4.2]
  def change
  	add_column :social_posts, :schedule, :boolean, default: false
  end
end
