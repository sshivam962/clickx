# frozen_string_literal: true

class Agency::PortfolioController < Agency::BaseController
  before_action :set_portfolio, only: %i[show edit update destroy]
  before_action :set_category, only: %i[index load_portfolio]
  before_action :set_agency_active_package_name, only: %i[index load_portfolio]

  def index
    @portfolios =
      Portfolio.includes(:images, :thumbnail)
               .active.common
               .where(category: @category)
               .order(created_at: :desc)

    @my_portfolios =
      Portfolio.includes(:images, :thumbnail)
               .active.where(agency_id: current_agency.id)
               .order(created_at: :desc)
  end

  def new
    @portfolio = Portfolio.new
    @portfolio.build_thumbnail
  end

  def load_portfolio
    @portfolios = Portfolio.includes(:images, :thumbnail)
                           .active.where(category: @category)
                           .order(created_at: :desc)

    content = render_to_string(
      partial: 'agency/portfolio/shared/list',
      locals: { portfolios: @portfolios, category: @category }
    )
    render json: { status: 200, message: '', data: { content: content }}
  end

  def show
    portfolios = Portfolio.includes(:images, :thumbnail)
                          .active.where(category: @portfolio.category)
                          .order(created_at: :desc)
    p_index = portfolios.index(@portfolio)
    @next_portfolio = portfolios[p_index + 1]
    @previous_portfolio = portfolios[p_index - 1] unless p_index.zero?
  end

  def create
    @portfolio = Portfolio.new(portfolio_params)
    if @portfolio.save
      flash[:success] = 'Portfolio Created Successfully'
      redirect_to agency_portfolio_index_path
    else
      flash[:error] = @portfolio.errors.full_messages.to_sentence
      @portfolio.build_thumbnail
      render :new
    end
  end

  def edit
    @portfolio.thumbnail || @portfolio.build_thumbnail
  end

  def update
    if @portfolio.agency_id == current_agency.id
      if @portfolio.update(portfolio_params)
        flash[:success] = 'Portfolio updated Successfully'
        redirect_to agency_portfolio_index_path
      else
        flash[:error] = @portfolio.errors.full_messages.to_sentence
        render :edit
      end
    else
      flash[:error] = "Access denied"
      redirect_to agency_portfolio_index_path
    end
  end

  def destroy
    if @portfolio.agency_id == current_agency.id
      @portfolio.destroy
    end
    redirect_to agency_portfolio_index_path
  end

  private

  def perform_authorization
    authorize current_agency, :portfolio?
  end

  def set_portfolio
    @portfolio = Portfolio.find(params[:id])
  end

  def set_category
    @category = params[:category].presence || Portfolio.categories.keys.first
  end

  def set_agency_active_package_name
    @agency_active_package_name = current_agency.active_package_name
  end

  def portfolio_params
    params.require(:portfolio)
          .permit(
            :agency_id, :category, :tier, :draft, :video_embed_code,
            images_attributes: [:id, :file, :_destroy],
            thumbnail_attributes: [:id, :file, :_destroy]
          )
  end
end
