class Addendum < ApplicationRecord
  belongs_to :agency

  mount_uploader :file, AgreementPdfUploader
  mount_base64_uploader :signature, SignatureUploader
end
