class AddTimeZoneToAgency < ActiveRecord::Migration[5.2]
  def change
    add_column :agencies, :time_zone_name, :string, default: "UTC"
    add_column :agencies, :start_time, :string, default: "10:00 AM"
    add_column :agencies, :end_time, :string, default: "11:00 AM"
  end
end