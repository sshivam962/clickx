class AddReadymodeUploadStatusToOutscrapperRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :outscrapper_requests, :readymode_upload_status, :integer, default: 0
  end
end
