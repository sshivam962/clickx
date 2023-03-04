class Thumbnail < ApplicationRecord
  belongs_to :thumbnailable, polymorphic: true

  mount_uploader :file, ImageUploader

  delegate :url, to: :file, allow_nil: true, prefix: true
end
