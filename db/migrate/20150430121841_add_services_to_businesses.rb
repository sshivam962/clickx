class AddServicesToBusinesses < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :local_profile_service,  :boolean, default: false
    add_column :businesses, :seo_service,            :boolean, default: false
    add_column :businesses, :ppc_service,            :boolean, default: false
    add_column :businesses, :live_chat_service,      :boolean, default: false
    add_column :businesses, :call_analytics_service, :boolean, default: false
    add_column :businesses, :retargeting_service,    :boolean, default: false

    add_column :businesses, :campaign_id,            :string 
    add_column :businesses, :ppc_iframe,             :string 
    add_column :businesses, :retargeting_iframe,     :string 
  end
end
