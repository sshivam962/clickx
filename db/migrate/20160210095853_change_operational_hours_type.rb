class ChangeOperationalHoursType < ActiveRecord::Migration[4.2]
  def up
    remove_column :locations, :operational_hours
    add_column :locations, :operational_hours, :boolean, default: false
  end

  def down
    remove_column :locations, :operational_hours
    add_column :locations, :operational_hours, :string, array: true, default: []
  end
end
