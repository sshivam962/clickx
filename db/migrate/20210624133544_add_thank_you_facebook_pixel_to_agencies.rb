class AddThankYouFacebookPixelToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :thank_you_facebook_pixel, :text
  end
end
