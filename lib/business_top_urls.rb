# frozen_string_literal: true
class BusinessTopUrls
  def initialize(business:)
    @business = business
  end

  def fetch_top_urls
    latest_data = Businesses::KeywordRanks.fetch(business, {})
    keyword_urls = latest_data.pluck('googleRankingUrl').compact
    backlinks = business&.backlink_datum&.backlinks
                        &.pluck('TargetURL')&.compact
    urls = (keyword_urls + [backlinks]).uniq.compact
    urls.map do |url|
      url.split('://').last
    end.uniq.compact
  end

  private

  attr_accessor :business
end
