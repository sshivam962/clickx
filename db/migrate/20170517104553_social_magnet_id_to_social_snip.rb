class SocialMagnetIdToSocialSnip < ActiveRecord::Migration[4.2]
  def change
    add_reference :social_snips, :social_magnet_template
    remove_column :social_snips, :template_id, :integer
  end
end
