class Lead::StrategyFunnel < ApplicationRecord
  acts_as_list scope: [:category, :funnel_type]

  scope :funnels, lambda { |params|
                           where(
                             category: params[:category],
                             funnel_type: params[:funnel_type]
                           ).order(:position)
                         }

  FUNNEL = {
    top_funnel: 'Top Funnel',
    middle_funnel: 'Middle Funnel',
    bottom_funnel: 'Bottom Funnel'
  }

  def category_key
    Lead::StrategyFunnel.categories[category]
  end

  def self.categories
    Lead::Strategy::CATEGORIES.except('SEO')
  end
end
