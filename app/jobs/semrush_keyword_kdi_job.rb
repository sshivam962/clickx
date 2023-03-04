class SemrushKeywordKdiJob
  include Sidekiq::Worker
  sidekiq_options queue: 'kw_priority_queue'

  def perform(keyword_id)
    keyword = SemrushKeyword.find(keyword_id)
    keyword.update(
      kdi: Semrush.keyword_difficulty(keyword.name)[:keyword_difficulty] || -1,
      kdi_last_updated_at: Date.current
    )
  end
end
