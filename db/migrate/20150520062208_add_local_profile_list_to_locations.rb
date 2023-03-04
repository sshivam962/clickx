class AddLocalProfileListToLocations < ActiveRecord::Migration[4.2]
  def change
    add_column :locations, :local_profile_list, :string 
    add_column :locations, :local_profile_last_upload, :datetime
  end
end
