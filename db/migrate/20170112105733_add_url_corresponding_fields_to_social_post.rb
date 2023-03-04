class AddUrlCorrespondingFieldsToSocialPost < ActiveRecord::Migration[4.2]
  def change
  	add_column :social_posts, :url_data, :string
  	add_column :social_posts, :url_title, :string
  	add_column :social_posts, :url_image, :string
  	add_column :social_posts, :url_short, :string
  end
end
