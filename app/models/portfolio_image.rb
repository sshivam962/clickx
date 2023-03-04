class PortfolioImage < ApplicationRecord
  belongs_to :portfolio

  mount_uploader :file, ImageUploader
end
