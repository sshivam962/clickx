class AddScaleZoomExpiryDateToAgency < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :scale_zoom_expiry_date, :datetime
  end
end
