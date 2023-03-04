class FileAttachment < ApplicationRecord
  belongs_to :file_attachable, polymorphic: true, optional: true

  mount_uploader :file, FileAttachmentUploader

  def display_name
    file.public_id.split('_')[0..-2].join('_')
  end
end
