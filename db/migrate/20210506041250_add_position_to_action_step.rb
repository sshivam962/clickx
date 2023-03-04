class AddPositionToActionStep < ActiveRecord::Migration[5.1]
  def change
    add_column :action_steps, :position, :integer
  end
end
