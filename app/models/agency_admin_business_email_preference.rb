# frozen_string_literal: true

class AgencyAdminBusinessEmailPreference < ApplicationRecord
  belongs_to :agency_admin, -> { where(role: :agency_admin) }, class_name: 'User', optional: true
  belongs_to :user
  belongs_to :business
  has_many :email_preferences, as: :ownable, dependent: :destroy
end
