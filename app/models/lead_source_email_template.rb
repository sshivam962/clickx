class LeadSourceEmailTemplate < ApplicationRecord
  belongs_to :email_template
  belongs_to :lead_source, inverse_of: :lead_source_email_templates, optional: true

  acts_as_list scope: [:lead_source_id]
end
