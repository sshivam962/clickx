class FacebookAdImage < ApplicationRecord
  belongs_to :facebook_ad

  mount_uploader :file, ImageUploader
end
