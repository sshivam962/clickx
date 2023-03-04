# frozen_string_literal: true
class SupportMember < ApplicationRecord
  # acts_as_paranoid

  belongs_to :agency
  validates :name, presence: true

  has_one :photo, as: :imageable, inverse_of: :imageable, class_name: 'Image'

  accepts_nested_attributes_for :photo,
                                reject_if: :all_blank,
                                allow_destroy: true

  def photo_url
    photo&.file&.url
  end
end
