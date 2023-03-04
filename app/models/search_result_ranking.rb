# frozen_string_literal: true
class SearchResultRanking < ApplicationRecord
  belongs_to :search_term
  scope :on, ->(rank_date) { where(rank_date: rank_date) }
  scope :on_or_before, (lambda do |href, rank_date|
    where('href = ? AND rank_date <= ?', href, rank_date)
      .order(rank_date: :desc)
  end)

  after_save :update_rank_change

  def self.first_or_dup_on(params)
    scope = where(href: params[:href], rank: params[:rank])

    first_element = scope.on(params[:rank_date]).first
    return first_element if first_element

    ranking =
      begin
        scope.on_or_before(params[:href], params[:rank_date]).first!.dup
      rescue ActiveRecord::RecordNotFound
        scope.order(rank_date: :desc).first_or_initialize
      end

    ranking.rank_date = params[:rank_date]
    ranking
  end

  def update_rank_change
    result_7_days_old =
      search_term.search_result_rankings
                 .on_or_before(href, rank_date - 7.days).first
    @last_7_days_change = result_7_days_old.rank - rank if result_7_days_old

    result_14_days_old =
      search_term.search_result_rankings
                 .on_or_before(href, rank_date - 14.days).first
    @last_14_days_change = result_14_days_old.rank - rank if result_14_days_old

    result_30_days_old =
      search_term.search_result_rankings
                 .on_or_before(href, rank_date - 30.days).first
    @last_30_days_change = result_30_days_old.rank - rank if result_30_days_old

    # so as to avoid infinite loop on calling after_save
    update_columns(last_7_days: @last_7_days_change,
                   last_14_days: @last_14_days_change,
                   last_30_days: @last_30_days_change)
  end
end
