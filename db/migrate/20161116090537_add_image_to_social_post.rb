class AddImageToSocialPost < ActiveRecord::Migration[4.2]
  def change
    add_column :social_posts, :image, :string
  end
end
