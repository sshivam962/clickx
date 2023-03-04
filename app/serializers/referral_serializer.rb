# frozen_string_literal: true

class ReferralSerializer < ActiveModel::Serializer
  attributes :id, :referrer_id, :referee_id, :eligibility, :rewarded, :notes
end
