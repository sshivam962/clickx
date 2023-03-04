class CreateCustomUrls < ActiveRecord::Migration[4.2]
  def change
    create_table :custom_urls do |t|
      t.string     :website_url
      t.string     :campaign_source
      t.string     :campaign_medium
      t.string     :campaign_name
      t.string     :campaign_term
      t.string     :campaign_content
      t.string     :complete_url
      t.integer    :business_id
      t.timestamps null: false
    end
  end
end
