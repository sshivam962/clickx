class AddSocialAccountAndCompletedToSocialPosts < ActiveRecord::Migration[4.2]
  def change
    add_column :social_posts, :social_account, :string
    add_column :social_posts, :completed, :boolean, default: false
  end
end
