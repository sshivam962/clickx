# frozen_string_literal: true

class MailTemplate < ApplicationRecord
  Types = [
    'Invitation',
    'New Customer Comment',
    'Content Feedback',
    'New Content',
    'Agency admin invitation'
  ].freeze

  validates :subject, :mail_type, :paragraph1, presence: true
  belongs_to :user, optional: true
end
