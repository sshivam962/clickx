# frozen_string_literal: true

class BacklinkHistory < ApplicationRecord
  belongs_to :business

  delegate :host, to: :business

  after_create do
    fetch_data tracked_date if tracked_date
    save
  end

  def fetch_data(date)
    self.tracked_date = date

    gained_data = Majestic.new_backlinks(host, tracked_date, tracked_date)
    self.gained = gained_data[:headers][:TotalBackLinks]

    lost_data = Majestic.lost_backlinks host, tracked_date, tracked_date
    self.lost = lost_data[:headers][:TotalBackLinks]
  end

  def updatable?
    (gained + lost).zero?
  end
end
