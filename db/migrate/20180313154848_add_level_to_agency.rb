class AddLevelToAgency < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :level, :integer
  end
end
