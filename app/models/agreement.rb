class Agreement < ApplicationRecord
  acts_as_paranoid

  belongs_to :agreementable, polymorphic: true

  mount_uploader :file, AgreementPdfUploader
  mount_base64_uploader :signature, SignatureUploader
end
