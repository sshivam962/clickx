# frozen_string_literal: true

module Keywords
  class CompetitorsRank
    attr_reader :keyword_name, :business

    def initialize(keyword_name, business)
      @keyword_name = keyword_name
      @business = business
    end

    def fetch
      return [] if competitors.blank? || domain_ranks.blank?
      competitors.map do |competitor|
        domain_ranks.map do |domain_rank|
          next if competitor.match?(domain_rank.domain).blank?
          {
            rank: domain_rank.rank,
            url: competitor
          }
        end
      end.flatten.compact
    end

    private

    def domain_ranks
      DomainRanking.where(keyword_name: keyword_name)
    end

    def competitors
      @_competitors ||= business.reload.competitions.pluck(:name)
    end
  end
end
