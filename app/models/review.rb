# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :location, counter_cache: true
  validates :email, :text, presence: { if: -> { directory == 'clickx' } }
  validates :directory, :name, presence: true
  validates :rating, numericality: true
  validates :unique_hash, uniqueness: { scope: :location_id, unless: -> { directory == 'clickx' } }
  before_create :set_clickx_review_fields, if: -> { directory == 'clickx' }

  scope :non_clickx, -> { where.not(directory: 'clickx') }
  scope :clickx, -> { where(directory: 'clickx') }
  scope :directory, ->(dir) { where(directory: dir) }
  scope :rating, ->(stars) { where(rating: stars) }
  scope :is_present?, ->(val) { where(hash: val).count > 0 }
  scope :top_rated, -> { where(rating: [4.0, 5.0]) }

  scope :order_dsc, -> { order(timestamp: :desc) }

  delegate :business, to: :location
  delegate :name, to: :location, prefix: true

  GOOGLE_MY_BUSINESS = 'https://business.google.com/manage/u/2/#/list'

  def url
    !!(directory =~ /google/) ? GOOGLE_MY_BUSINESS : super
  end

  private

  def set_clickx_review_fields
    self.name = 'Clickx'
    self.timestamp = Time.current
  end
end
