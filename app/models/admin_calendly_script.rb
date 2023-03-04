class AdminCalendlyScript < ApplicationRecord
  validates :user_id, presence: true, uniqueness: true
  validates :calendly_script, presence: true
  belongs_to :user, optional: true
end
