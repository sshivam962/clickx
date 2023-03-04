# frozen_string_literal: true
class KeywordTag < ApplicationRecord
  belongs_to :business
  has_many :taggables
  has_many :keywords, through: :taggables

  validates :name, presence: true, uniqueness: {
    message: 'There is another tag with the same name'
  }
  validates :color, presence: true
end
