# frozen_string_literal: true

class SuperAdmin::Lead::StrategyItemsController < SuperAdmin::BaseController
  before_action :perform_authorization
  before_action :set_strategy_item,
                only: %i[edit update destroy favorite load_item]
  before_action :set_lead, only: :load_item

  def index; end

  def create
    @strategy_item = ::Lead::StrategyItem.create(strategy_item_params)
  end

  def update
    @strategy_item.update(strategy_item_params)
  end

  def destroy
    @strategy_item.destroy
  end

  def favorite
    @strategy_item.toggle!(:favorite)
  end

  def load_item; end

  private

  def strategy_item_params
    params.require(:lead_strategy_item).permit(:strategy, :category)
  end

  def set_strategy_item
    @strategy_item = ::Lead::StrategyItem.find(params[:id])
  end

  def set_lead
    @lead = ::Lead.find(params[:lead_id])
  end

  def perform_authorization
    authorize %i[super_admin lead strategy_item]
  end
end
