# frozen_string_literal: true

class SocialMediaPrompt < ApplicationRecord
  validates :title, presence: true
  validates :prompt, presence: true
  
end
