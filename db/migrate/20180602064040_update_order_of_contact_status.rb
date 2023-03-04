class UpdateOrderOfContactStatus < ActiveRecord::Migration[5.1]
  def up
    TrackerContact.where('status = 2').update_all(status: 3)
    TrackerContact.where('status = 1').update_all(status: 2)
    TrackerContact.where('status = 3').update_all(status: 1)
  end

  def down
    TrackerContact.where('status = 2').update_all(status: 3)
    TrackerContact.where('status = 1').update_all(status: 2)
    TrackerContact.where('status = 3').update_all(status: 1)
  end
end
