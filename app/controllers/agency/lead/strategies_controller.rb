# frozen_string_literal: true

class Agency::Lead::StrategiesController < Agency::BaseController
  before_action :set_lead
  before_action :set_lead_strategy, only: %i[edit update archive reorder_items]
  before_action :set_archived_lead_strategy, only: :unarchive
  before_action :ensure_access, only: %i[edit create update reorder_items]
  before_action :verify_strategy_limit, only: %i[create new]

  def new
    if ::Lead::Strategy::CATEGORIES.include?(params[:category])
      @lead_strategy =
        ::Lead::Strategy.new(
          category: params[:category], status: 'in_process',
          ad_spend_info: 'Recommended Ad Spend: between $1,500 - $4,999'
        )
      @strategy_items = fetch_strategy_items
    else
      flash[:error] = 'Invalid Strategy Template'
      redirect_to agency_leads_path
    end
  end

  def create
    @lead_strategy = @lead.lead_strategies.new(lead_strategy_params)
    if @lead_strategy.save
      flash[:success] = 'Strategy created'
      redirect_to redirect_path_after_update
    else
      flash[:error] = @lead_strategy.errors.full_messages.to_sentence
      @strategy_items = fetch_strategy_items
      render 'new'
    end
  end

  def update
    if @lead_strategy.update(lead_strategy_params)
      flash[:success] = 'Strategy updated'
      redirect_to redirect_path_after_update
    else
      flash[:error] = @lead_strategy.errors.full_messages.to_sentence
      redirect_to edit_agency_lead_strategy_path(@lead_strategy)
    end
  end

  def edit
    @strategy_items = fetch_strategy_items
  end

  def reorder_items; end

  def archive
    @lead_strategy.destroy
    set_strategies_body_items
  end

  def unarchive
    @lead_strategy.update(deleted_at: nil)
    set_strategies_body_items
  end

  private

  def lead_strategy_params
    params.require(:lead_strategy).permit(
      :category, :ad_spend_info, strategies: [],
      strategy_images_attributes: [:id, :file, :_destroy]
    ).merge(status: 'approved', created_by: 'agency_admin')
  end

  def set_lead
    @lead = ::Lead.find(params[:lead_id])
  end

  def fetch_strategy_items
    ::Lead::StrategyItem.send(
      ::Lead::Strategy::CATEGORIES[@lead_strategy.category]
    ).favorite
  end

  def set_lead_strategy
    @lead_strategy = ::Lead::Strategy.find(params[:id])
  end

  def set_archived_lead_strategy
    @lead_strategy = ::Lead::Strategy.only_deleted.find(params[:id])
  end

  def ensure_access
    return if @lead.agency.eql?(current_agency)

    flash[:error] = 'Access denied'
    redirect_to agency_leads_path
  end

  def verify_strategy_limit
    this_month_strategies_count = current_agency.this_month_strategies.count
    return if this_month_strategies_count < current_agency.strategy_limit

    flash[:error] = 'This monthly strategy limit exceeded!'
    redirect_to agency_leads_path
  end

  def set_strategies_body_items
    @strategies = @lead.lead_strategies.with_deleted.group_by(&:category)
    @strategy_limit = current_agency.strategy_limit
    @this_month_strategies = current_agency.this_month_strategies
  end

  def redirect_path_after_update
    if params[:submit].eql?('reorder_items')
      reorder_items_agency_lead_strategy_path(@lead, @lead_strategy)
    elsif params['reorder_item_redirect'].present?
      edit_agency_lead_strategy_path(@lead, @lead_strategy)
    else
      agency_leads_path
    end
  end
end
