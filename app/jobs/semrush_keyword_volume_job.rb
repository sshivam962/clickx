class SemrushKeywordVolumeJob
  include Sidekiq::Worker
  sidekiq_options queue: 'kw_priority_queue'

  def perform(keyword_id)
    keyword = SemrushKeyword.find(keyword_id)
    keyword.update(
      search_volume: Semrush.semrush_keyword_search_volume(keyword.name)[:search_volume],
      search_volume_last_updated_at: Date.current
    )
  end
end
