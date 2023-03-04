class RemoveAccentColorLogoSupportEmailFromBusinesses < ActiveRecord::Migration[4.2]
  def change
    remove_column :businesses, :logo, :string
    remove_column :businesses, :support_email, :string
    remove_column :businesses, :accent_color, :string
  end
end
