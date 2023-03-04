class AddSocialMediaToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :is_social_media_ad, :boolean, default: false
  end
end
