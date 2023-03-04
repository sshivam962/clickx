class WatchHistory < ApplicationRecord
  belongs_to :user
  belongs_to :chapter
  belongs_to :course

  before_create :set_first_seen

  private

  def set_first_seen
    self.first_seen = Time.now
  end
end
