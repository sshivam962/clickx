class Agency::FunnelPagesController < Agency::BaseController
  layout :resolve_layout
  before_action :set_funnel_page, only: %i[update show edit destroy preview]
  before_action :set_funnel_page_clone, only: :new
  before_action :set_funnel_page_form, only: :preview

  def index
    @funnel_pages = FunnelPage.published.order(:title)
                              .paginate(per_page: 20, page: params[:page])
  end

  def show; end

  def new
    @funnel_page ||= FunnelPage.new
  end

  def create
    @funnel_page = FunnelPage.new(funnel_page_params)
    if @funnel_page.save
      flash[:success] = 'FunnelPage Created Successfully'
      redirect_to agency_industries_path
    else
      flash[:error] = @funnel_page.errors.full_messages.to_sentence
      redirect_to new_agency_funnel_page_path(@funnel_page)
    end
  end

  def update
    if @funnel_page.update(funnel_page_params)
      flash[:success] = 'FunnelPage Updated Successfully'
      redirect_to agency_industries_path
    else
      flash[:error] = @funnel_page.errors.full_messages.to_sentence
      redirect_to edit_agency_funnel_page_path(@funnel_page)
    end
  end

  def destroy
    @funnel_page.destroy
    flash[:success] = 'FunnelPage Reverted Successfully'
    redirect_to agency_industries_path
  end

  private

  def set_funnel_page
    @funnel_page ||= FunnelPage.find_by(id: params[:id])
  end

  def resolve_layout
    case action_name
    when 'preview'
      'public/funnel_page'
    else
      'aa_themeX_base'
    end
  end

  def funnel_page_params
    params.require(:funnel_page).permit(
      :title, :css, :draft, :industry_id, :lead_form_required,
      :section_a, :section_b, :section_c, :section_d, :section_e, :section_f, :agency_id, :funnel_page_id
    )
  end

  def set_funnel_page_clone
    @funnel_page = FunnelPage.find_by(id: params[:copy_from])
    return if @funnel_page.blank?

    @funnel_page.draft = false
  end

  def set_funnel_page_form
    @agency_niche = AgencyNiche.find_or_create_by(
      agency_id: current_agency.id,
      industry_id: @funnel_page.industry_id
    )
  end

end
