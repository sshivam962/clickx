class AddROIHeaderColorToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :roi_header_color, :string, default: '#4C4E60'
  end
end
