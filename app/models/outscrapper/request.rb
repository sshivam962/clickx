# frozen_string_literal: true

class Outscrapper::Request < ApplicationRecord
  acts_as_paranoid
  belongs_to :agency
  belongs_to :user,
    class_name: 'User',
    foreign_key: :created_by,
    optional: true
  has_one :outscrapper_data, class_name: 'Outscrapper::Data',
    dependent: :destroy, foreign_key: :outscrapper_request_id
  validates :agency_id, presence: true

  enum readymode_upload_status: {
    pending: 0,
    processing: 1,
    completed:2,
    failed: 3
  }

  scope :in_the_last_month, -> { where('created_at > ?', Date.today - 30.days) }
end
