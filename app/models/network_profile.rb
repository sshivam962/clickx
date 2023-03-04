class NetworkProfile < ApplicationRecord
  belongs_to :user
  has_many :skills, inverse_of: :network_profile, dependent: :destroy
  has_many :network_portfolios, inverse_of: :network_profile, dependent: :destroy
  has_many :work_profiles, inverse_of: :network_profile, dependent: :destroy
  accepts_nested_attributes_for :skills, :network_portfolios, :work_profiles, reject_if: :all_blank, allow_destroy: true
  has_one :network_membership, inverse_of: :network_profile, dependent: :destroy
  has_one :agreement, as: :agreementable, class_name: 'Agreement',
          dependent: :destroy

  has_many :case_studies

  def agreement_signed?
    agreement&.signed?
  end

  def network_membership
    super || create_network_membership
  end
end
