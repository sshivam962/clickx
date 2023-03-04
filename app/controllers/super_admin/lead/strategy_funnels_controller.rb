class SuperAdmin::Lead::StrategyFunnelsController < SuperAdmin::BaseController
  before_action :set_funnel, only: %i[update destroy move_position]

  def index; end

  def create
    if @funnel = ::Lead::StrategyFunnel.create(funnel_params)
      @c_key = @funnel.category_key
      @f_key = @funnel.funnel_type
      respond_to do |format|
        format.html { redirect_to super_admin_strategy_funnels_path(tab: @funnel.category_key), notice: 'Strategy funnel created.' }
        format.js
      end
    end
  end

  def update
    if @funnel.update(funnel_params)
      respond_to do |format|
        format.html { redirect_to super_admin_strategy_funnels_path(tab: @funnel.category_key), notice: 'Strategy funnel updated.' }
        format.js
      end
    end
  end

  def destroy
    @funnel.destroy
    ::Lead::StrategyFunnel.funnels(category: @funnel.category, funnel_type: @funnel.funnel_type).each_with_index do |funnel, index|
      funnel.update(position: index + 1)
    end

    respond_to do |format|
      format.html { redirect_to super_admin_strategy_funnels_path(tab: @funnel.category_key), notice: "Strategy funnel deleted" }
      format.js
    end
  end

  def move_position
    @funnel.insert_at(params[:position].to_i)
    head :ok
  end

  private

  def funnel_params
    params.require(:lead_strategy_funnel)
          .permit(:funnel_type, :category, :content)
  end

  def set_funnel
    @funnel = ::Lead::StrategyFunnel.find(params[:id])
  end
end
