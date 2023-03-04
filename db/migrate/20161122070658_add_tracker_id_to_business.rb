class AddTrackerIdToBusiness < ActiveRecord::Migration[4.2]
  def up
    add_column :businesses,:tracker_id,:string,unique: true,index: true
    Business.find_each do |business|
        business.update_attributes(tracker_id: SecureRandom.uuid)
    end
  end

  def down
    remove_column :businesses,:tracker_id
  end
end
