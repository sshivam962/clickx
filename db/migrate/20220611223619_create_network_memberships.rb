class CreateNetworkMemberships < ActiveRecord::Migration[5.2]
  def change
    create_table :network_memberships do |t|
      t.references :network_profile, foreign_key: true
      t.boolean :community_joined
      t.boolean :publish_blog
      t.boolean :fb_profile_add
      t.boolean :social_links_add
      t.boolean :post_about_network
      t.boolean :personal_social_links_add
      t.boolean :linkedin_add
      t.timestamps
    end
  end
end
