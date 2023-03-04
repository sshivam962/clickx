class AddFacebookPixelToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :facebook_pixel, :text
  end
end
