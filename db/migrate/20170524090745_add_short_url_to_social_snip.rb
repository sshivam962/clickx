class AddShortUrlToSocialSnip < ActiveRecord::Migration[4.2]
  def change
    add_column :social_snips, :short_url, :string
    add_column :social_snips, :snip_url, :string
  end
end
