# frozen_string_literal: true

class UpdateSvAndCpcJob
  include Sidekiq::Worker
  def perform
    # TODO: search volume by location?
    # Avoid duplicate calls to semrush for keywords with same name
    ActiveRecord::Base.connection_pool.with_connection do
      Keyword.joins(:business).where("businesses.deleted_at is null").find_each(batch_size: 10) do |keyword|
        next if keyword.name.blank?
        search_volume_data = Semrush.keyword_search_volume(keyword.name).first
        next if search_volume_data.blank?

        keyword_ranking = keyword.keyword_rankings.last
        keyword_ranking.search_volume = search_volume_data[:search_volume]
        keyword_ranking.cpc = search_volume_data[:cpc]
        keyword_ranking.save
      end
    end
  end
end
