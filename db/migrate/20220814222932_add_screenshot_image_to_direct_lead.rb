class AddScreenshotImageToDirectLead < ActiveRecord::Migration[5.2]
  def change
    add_column :direct_leads, :screenshot_image, :string
  end
end
