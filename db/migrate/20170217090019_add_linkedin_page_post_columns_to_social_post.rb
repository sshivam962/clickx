class AddLinkedinPagePostColumnsToSocialPost < ActiveRecord::Migration[4.2]
  def up
    add_column :social_posts, :linkedin_page_ids, :string, array: true, default: []
    add_column :social_posts, :completed_linkedin_page_ids, :string, array: true, default: []
    add_column :social_posts, :linkedin_page_post_ids, :json, default: {}
  end
  
  def down
    remove_column :social_posts, :linkedin_page_ids
    remove_column :social_posts, :completed_linkedin_page_ids
    remove_column :social_posts, :linkedin_page_post_ids
  end
end
