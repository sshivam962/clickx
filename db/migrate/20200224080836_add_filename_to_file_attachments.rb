class AddFilenameToFileAttachments < ActiveRecord::Migration[5.1]
  def change
    add_column :file_attachments, :filename, :string
  end
end
