class AddScaleZoomInfoToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :scale_zoom_info, :boolean, default: false
  end
end
