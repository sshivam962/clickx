class ChangeLeadSourcePhoneToPhoneCall < ActiveRecord::Migration[4.2]
  def up
    TrackerContact.where(source: 'phone').update_all(source: 'phone_call')
  end

  def down
    TrackerContact.where(source: 'phone_call').update_all(source: 'phone')
  end
end
