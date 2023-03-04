class LeadSourceFile < ApplicationRecord
  belongs_to :lead_source

  mount_uploader :filename, ListCsvUploader
end
