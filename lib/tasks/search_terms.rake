# frozen_string_literal: true

namespace :search_terms do
  desc 'Fetch Search Result Rank Info'
  task update_ranks: :environment do
    if Date.current.monday? || Date.current.thursday?
      SearchTerm.find_each do |search_term|
        next if search_term.business.blank?
        next unless search_term.business.reputation_service?
        AddToDelayedQueueJob.perform_async(
          search_term.name, 'google', search_term.city, 'search_result_ranking', search_term.locale
        )
      end
    end
  end
end
