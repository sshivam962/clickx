class AddFieldsToTrackerContact < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_contacts,:source,:string
    add_column :tracker_contacts,:provider,:string
    add_column :tracker_contacts,:do_not_call,:boolean,default: false
    add_column :tracker_contacts,:do_not_email,:boolean,default: false
    add_column :tracker_contacts,:background_info,:text
    add_column :tracker_contacts,:status,:integer,default: 0
    add_column :tracker_contacts,:provider_meta_data,:jsonb
  end
end
