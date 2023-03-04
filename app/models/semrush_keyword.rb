class SemrushKeyword < ApplicationRecord
  belongs_to :business

  scope :with_ranking, -> { where('rank > 0 AND rank < 100') }

  def set_kdi
    SemrushKeywordKdiJob.perform_async(id)
  end

  def set_search_volume
    SemrushKeywordVolumeJob.perform_async(id)
  end

  def self.search(search_term)
    search_term ||= ''
    where('name ILIKE ?', "%#{search_term}%")
  end

  def kdi_updatable?
    kdi_last_updated_at.nil? || kdi_last_updated_at < Date.current.weeks_ago(2)
  end

  def volume_updatable?
    search_volume_last_updated_at.nil? || search_volume_last_updated_at < Date.current.weeks_ago(2)
  end
end
