# frozen_string_literal: true

class SuperAdmin::FunnelPagesController < SuperAdmin::BaseController
  layout :resolve_layout
  before_action :perform_authorization
  before_action :set_funnel_page, only: %i[update destroy edit preview]
  before_action :set_funnel_page_clone, only: :new
  before_action :set_agency, only: :preview
  before_action :set_funnel_page_form, only: :preview

  def create
    @funnel_page = FunnelPage.new(funnel_page_params)
    if @funnel_page.save
      flash[:success] = 'FunnelPage created Successfully'
      redirect_to super_admin_funnel_pages_path
    else
      flash[:error] = @funnel_page.errors.full_messages.to_sentence
      redirect_to new_super_admin_funnel_page_path(@funnel_page)
    end
  end

  def index
    @funnel_pages = FunnelPage.where(search_query).order(:title)
                              .paginate(page: params[:page], per_page: 20)
  end

  def new
    @funnel_page ||= FunnelPage.new
  end

  def update
    if @funnel_page.update(funnel_page_params)
      flash[:success] = 'FunnelPage Updated Successfully'
      redirect_to super_admin_funnel_pages_path
    else
      flash[:error] = @funnel_page.errors.full_messages.to_sentence
      redirect_to edit_super_admin_funnel_page_path(@funnel_page)
    end
  end

  def destroy
    @funnel_page.destroy
    redirect_to super_admin_funnel_pages_path
  end

  def preview
    @privacy_policy = PrivacyPolicy.first
    render 'public/funnel_pages/show'
  end

  private

  def perform_authorization
    authorize %i[super_admin funnel_page]
  end

  def funnel_page_params
    params.require(:funnel_page).permit(
      :title, :css, :draft, :industry_id, :lead_form_required,
      :section_a, :section_b, :section_c, :section_d, :section_e, :section_f
    )
  end

  def set_funnel_page
    @funnel_page ||= FunnelPage.find_by(id: params[:id])
  end

  def search_query
    return '' if params[:title].blank?

    "lower(funnel_pages.title) ILIKE '%#{params[:title]}%'"
  end

  def resolve_layout
    case action_name
    when 'preview'
      'public/funnel_page'
    else
      'base'
    end
  end

  def set_funnel_page_clone
    @funnel_page = FunnelPage.find_by(id: params[:copy_from])
    return if @funnel_page.blank?

    @funnel_page.title = "#{@funnel_page.title} Copy"
    @funnel_page.draft = true
  end

  def set_agency
    @agency = Agency.find_by(name: 'OneIMS')
  end

  def set_funnel_page_form
    @agency_niche = AgencyNiche.find_or_create_by(
      agency_id: @agency.id,
      industry_id: @funnel_page.industry_id
    )
  end
end
