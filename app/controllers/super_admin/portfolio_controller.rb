class SuperAdmin::PortfolioController < ApplicationController
  layout :resolve_layout
  before_action :perform_authorization
  before_action :set_portfolio, only: %i[edit update destroy preview]

  def index
    @portfolios =
      Portfolio.includes(:images, :thumbnail).order(created_at: :desc)
  end

  def new
    @portfolio = Portfolio.new
    @portfolio.build_thumbnail
  end

  def preview
    @agency = Agency.find_by(name: 'OneIMS')
    @portfolios = Portfolio.includes(:images, :thumbnail)
    render 'public/portfolios/show'
  end

  def create
    @portfolio = Portfolio.new(portfolio_params)
    if @portfolio.save
      flash[:success] = 'Portfolio updated Successfully'
      redirect_to super_admin_portfolio_index_path
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
    if @portfolio.update(portfolio_params)
      flash[:success] = 'Portfolio updated Successfully'
      redirect_to super_admin_portfolio_index_path
    else
      flash[:error] = @portfolio.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @portfolio.destroy
    redirect_to super_admin_portfolio_index_path
  end

  def sort
    params[:portfolio].each_with_index do |id, index|
      Portfolio.where(id: id).update_all(position: index + 1)
    end

    head :ok
  end

  private

  def portfolio_params
    params.require(:portfolio)
          .permit(
            :agency_id, :category, :tier, :draft, :video_embed_code,
            images_attributes: [:id, :file, :_destroy],
            thumbnail_attributes: [:id, :file, :_destroy]
          )
  end

  def set_portfolio
    @portfolio = Portfolio.find(params[:id])
  end

  def perform_authorization
    authorize %i[super_admin portfolio]
  end

  def resolve_layout
    case action_name
    when 'preview'
      'plain'
    else
      'base'
    end
  end
end
