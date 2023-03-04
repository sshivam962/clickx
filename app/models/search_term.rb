# frozen_string_literal: true
class SearchTerm < KeywordBase
  has_many :search_result_rankings, dependent: :delete_all
  has_many :latest_rankings,
           ->(st) { where(rank_date: st.last_updated).order(:rank) },
           class_name: 'SearchResultRanking',
           dependent: :delete_all

  after_create :queue_for_ranking, if: :active?

  private

  def queue_for_ranking
    if (Rails.env.production? || Rails.env.staging?) && active?
      AddToPriorityQueueJob.perform_async(
        name, 'google', city, 'search_result_ranking', locale
      )
    end
  end
end
