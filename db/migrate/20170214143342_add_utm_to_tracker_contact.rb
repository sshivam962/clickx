class AddUtmToTrackerContact < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_contacts, :source_utm, :jsonb
    TrackerContact.reset_column_information 
    TrackerContact.with_deleted.joins(:visits).where("tracker_visits.utm IS NOT NULL").find_each do |contact|
      contact.source_utm = contact.visits.where("utm IS NOT NULL").first.utm
      contact.save
    end 
  end
end
