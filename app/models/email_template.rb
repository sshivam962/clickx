class EmailTemplate < ApplicationRecord
  belongs_to :agency

  has_many :lead_source_email_templates, dependent: :destroy, inverse_of: :email_template

  scope :enabled, -> { where(:enabled => true)}
end
