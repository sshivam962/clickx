# frozen_string_literal: true

class Video < ApplicationRecord
  validates :title, :embed_code, :category, presence: true
end
