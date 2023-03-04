# frozen_string_literal: true
class Taggable < ApplicationRecord
  validates :keyword, :keyword_tag, presence: true

  belongs_to :keyword
  belongs_to :keyword_tag
end
