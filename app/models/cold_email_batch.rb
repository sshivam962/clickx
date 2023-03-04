class ColdEmailBatch < ApplicationRecord
  belongs_to :lead_source
  has_one :cold_email_automate_sedning_report, class_name: "ColdEmailAutomateSedningReport"

  enum status: { processing: 0, completed: 1, failed: 2 }
end
