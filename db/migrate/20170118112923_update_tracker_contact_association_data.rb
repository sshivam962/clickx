class UpdateTrackerContactAssociationData < ActiveRecord::Migration[4.2]
  def change
    TrackerContact.with_deleted.where.not(tracker_visitor_id: nil).each do|contact| 
      contact.update_attributes(tracker_visitors: [TrackerVisitor.find(contact.tracker_visitor_id)])
    end
  end
end
