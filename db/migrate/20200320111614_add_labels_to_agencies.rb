class AddLabelsToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :labels, :text
  end
end
