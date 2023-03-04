class AddMediaToSocialPost < ActiveRecord::Migration[4.2]
  def change
    add_column :social_posts, :media, :string
    add_column :social_posts, :job_id, :string
  end
end
