class AddExpiryDateTimeToWelcomeBanners < ActiveRecord::Migration[5.2]
  def change
    add_column :welcome_banners, :expiry_date_time, :string
  end
end
