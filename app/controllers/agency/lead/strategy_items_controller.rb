# frozen_string_literal: true

class Agency::Lead::StrategyItemsController < Agency::BaseController
  before_action :set_strategy_item, only: :load_item
  before_action :set_lead, only: :load_item

  def load_item; end

  private

  def set_strategy_item
    @strategy_item = ::Lead::StrategyItem.find(params[:id])
  end

  def set_lead
    @lead = ::Lead.find(params[:lead_id])
  end
end
