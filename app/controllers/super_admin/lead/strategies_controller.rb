# frozen_string_literal: true

class SuperAdmin::Lead::StrategiesController < SuperAdmin::BaseController
  layout :resolve_layout

  before_action :perform_authorization
  before_action :set_lead,
                only: %i[
                  index new update create edit send_approval reorder_items carousel_preview preview
                ]
  before_action :set_lead_strategy,
                only: %i[update edit send_approval reorder_items carousel_preview preview]
  before_action :authorize_action, only: %i[update edit reorder_items]

  def list_leads
    @leads = {
      new_leads: new_leads,
      in_process: in_process_leads,
      pending_approval: pending_approval_leads,
      approved: approved_leads,
      old_leads: old_leads
    }
  end

  def new
    @lead_strategy =
      ::Lead::Strategy.new(
        category: params[:type], status: 'in_process',
        ad_spend_info: 'Recommended Ad Spend: between $1,500 - $4,999'
      )
    @strategy_items = fetch_strategy_items
    @lead_strategy.strategies = fetch_strategy_items.favorite.pluck(:strategy)
  end

  def create
    @lead_strategy = @lead.lead_strategies.new(lead_strategy_params)
    @lead_strategy.status = strategy_status

    if @lead_strategy.save
      flash[:success] = 'Strategy created'
      redirect_to redirect_path_after_update
    else
      flash[:error] = @lead_strategy.errors.full_messages.to_sentence
      @strategy_items = fetch_strategy_items
      render 'new'
    end
  end

  def edit
    @strategy_items = fetch_strategy_items
  end

  def reorder_items; end

  def update
    @lead_strategy.status = strategy_status
    if @lead_strategy.update(lead_strategy_params)
      flash[:success] = 'Strategy updated'
      redirect_to redirect_path_after_update
    else
      flash[:error] = @lead_strategy.errors.full_messages.to_sentence
      redirect_to edit_super_admin_lead_strategy_path(@lead_strategy)
    end
  end

  def preview
    render 'public/lead/strategies/show'
  end

  def carousel_preview
    render 'public/lead/strategies/carousel'
  end

  def send_approval
    @lead_strategy.send_approved_email
  end

  private

  def new_leads
    page = params[:status].eql?('new_leads') ? params[:page] : 1
    ::Lead.includes(:lead_strategies, agency: :growth_subscriptions)
          .where(old_strategy: false)
          .where(lead_strategies: { id: nil })
          .where(search_query)
          .order(created_at: :desc)
          .paginate(page: page, per_page: 30)
  end

  def in_process_leads
    page = params[:status].eql?('in_process') ? params[:page] : 1
    ::Lead.includes(:lead_strategies, agency: :growth_subscriptions)
          .where(old_strategy: false)
          .where(lead_strategies: { status: 'in_process' })
          .where(search_query)
          .order(created_at: :desc)
          .paginate(page: page, per_page: 30)
  end

  def pending_approval_leads
    page = params[:status].eql?('pending_approval') ? params[:page] : 1
    ::Lead.includes(:lead_strategies, agency: :growth_subscriptions)
          .where(old_strategy: false)
          .where(lead_strategies: { status: 'pending_approval' })
          .where(search_query)
          .order(created_at: :desc)
          .paginate(page: page, per_page: 30)
  end

  def approved_leads
    page = params[:status].eql?('approved') ? params[:page] : 1
    ::Lead.includes(:lead_strategies, agency: :growth_subscriptions)
          .where(old_strategy: false)
          .where(lead_strategies: { status: 'approved' })
          .where(search_query)
          .order(created_at: :desc)
          .paginate(page: page, per_page: 30)
  end

  def old_leads
    page = params[:status].eql?('old_leads') ? params[:page] : 1
    ::Lead.includes(:lead_strategies, agency: :growth_subscriptions)
          .where(old_strategy: true)
          .where(search_query)
          .order(created_at: :desc)
          .paginate(page: page, per_page: 30)
  end

  def lead_strategy_params
    params.require(:lead_strategy).permit(
      :category, :ad_spend_info, strategies: [],
      strategy_images_attributes: [:id, :file, :_destroy]
    )
  end

  def set_lead
    @lead = ::Lead.find(params[:lead_id])
  end

  def set_lead_strategy
    @lead_strategy = ::Lead::Strategy.find(params[:id])
  end

  def in_process_strategies
    ::Lead::Strategy::CATEGORIES.keys -
      @lead.lead_strategies.where.not(status: 'in_process').pluck(:category)
  end

  def new_strategies
    ::Lead::Strategy::CATEGORIES.keys - @lead.lead_strategies.pluck(:category)
  end

  def perform_authorization
    authorize %i[super_admin lead strategy]
  end

  def authorize_action
    return unless params[:submit].eql?('approved')
    return if ApplicationPolicy.new(current_user, nil).leads?

    flash[:error] = 'Access denied'
    redirect_to super_admin_strategy_leads_path
  end

  def strategy_status
    case params['submit']
    when 'approved'
      'approved'
    when 'pending_approval'
      'pending_approval'
    else
      'in_process'
    end
  end

  def fetch_strategy_items
    ::Lead::StrategyItem.send(
      ::Lead::Strategy::CATEGORIES[@lead_strategy.category]
    )
  end

  def search_query
    return '' if params[:name].blank? && params[:agency].blank?

    q = []
    if params[:name].present?
      q.push("(CONCAT_WS(' ', lower(leads.first_name), lower(leads.last_name)) ILIKE '%#{params[:name]}%' OR lower(leads.email) ILIKE '%#{params[:name]}%' OR lower(leads.domain) ILIKE '%#{params[:name]}%')")
    end
    if params[:agency].present?
      q.push("leads.agency_id = #{params[:agency]}")
    end
    q.join(' AND ')
  end

  def resolve_layout
    case action_name
    when 'preview'
      'public/lead_strategy'
    when 'carousel_preview'
      'public/lead_strategy'
    else
      'base'
    end
  end

  def redirect_path_after_update
    if params[:submit].eql?('reorder_items')
      reorder_items_super_admin_lead_strategy_path(@lead, @lead_strategy)
    else
      agency_leads_path
    end
  end
end
