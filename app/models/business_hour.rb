# frozen_string_literal: true

class BusinessHour < ApplicationRecord
  belongs_to :location

  def from_1
    from.to_s[0..4] if from.length == 7
  end

  def from_2
    from.to_s[5..7] if from.length == 7
  end

  def to_1
    to.to_s[0..4] if from.length == 7
  end

  def to_2
    to.to_s[5..7] if from.length == 7
  end
end
