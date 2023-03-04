# frozen_string_literal: true

class Activity < ApplicationRecord
  belongs_to :business
  belongs_to :user

  attr_accessor :date, :num_rows, :human_date

  def as_json(_options = {})
    super(only: %i[revisions created_at]).merge(user: user&.name)
  end
end
