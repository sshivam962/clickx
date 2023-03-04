class ColdEmailAutomateSedningReport < ApplicationRecord
  belongs_to :cold_email_batch, optional: true

end
