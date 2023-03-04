# frozen_string_literal: true

class Agency::IndustriesController < Agency::BaseController
  before_action :perform_authorization
  before_action :set_industry, only: %i[favorite]
  include AgencyCaseStudyManager

  def index
    fetch_my_casestudy_industries
    fetch_favorite_industries
    fetch_remaining_industries
    @fav_case_studies = []
    @rem_case_studies = []
    if params[:q].present? || (get_cookie(:agency_case_study_filters).present? && get_cookie(:agency_case_study_filters)[:q].present?)
      @agency_active_package_name = current_agency.active_package_name
      fetch_favorite_case_studies
      fetch_remaining_case_studies
    end
    @agency_niches_access = current_agency.agency_niches_accesses
  end

  def favorite
    if current_user.favorited_industries.include?(@industry)
      current_user.favorite_industries.where(industry_id: @industry.id).destroy_all
      @favorite = false
    else
      current_user.favorited_industries << @industry
      @favorite = true
    end

    fetch_my_casestudy_industries
    fetch_favorite_industries
    fetch_remaining_industries
    @agency_niches_access = current_agency.agency_niches_accesses
  end

  def update_lead_form
    agency_niche = AgencyNiche.find_or_create_by(
      agency_id: current_agency.id,
      industry_id: params[:id]
    )

    agency_niche.update(agency_niche_params)

    redirect_to agency_industries_path
  end

  private

  def set_industry
    @industry = Industry.find(params[:id])
  end

  def perform_authorization
    authorize current_agency, :industries?
  end

  def fetch_favorite_industries
    @fav_industries =
      current_user.favorited_industries
                  .includes(:case_studies, :funnel_page)
                  .where.not(case_studies: {id: nil})
                  .where(agency_where_query)
                  .where(filter_query_industry)
                  .order(updated_at: :asc)
  end

  def fetch_my_casestudy_industries
    @my_case_study_industries =
      Industry.includes(:case_studies, :funnel_page)
              .where.not(case_studies: {id: nil})
              .where(case_studies: {agency_id: current_agency.id})
              .where(agency_where_query)
              .where(filter_query_industry)
              .order(updated_at: :asc)
  end
   
  def fetch_remaining_industries
    @industries =
      Industry.includes(:case_studies, :funnel_page, :favorite_industries)
              .where.not(id: @fav_industries.ids)
              .where.not(case_studies: {id: nil})
              .where(agency_where_query)
              .where(filter_query_industry)
              .order(title: :asc)
  end

  def fetch_favorite_case_studies
    @case_studies = CaseStudy.includes(:industries).published.where(filter_query_case_study).order(created_at: :desc)
    @fav_case_studies = @case_studies.select { |case_study| case_study if current_user.favorited_case_studies.include?(case_study)}
  end

  def fetch_remaining_case_studies
    @case_studies = CaseStudy.includes(:industries).published.where(filter_query_case_study).order(created_at: :desc)
    @rem_case_studies = @case_studies.select { |case_study| case_study if current_user.favorited_case_studies.exclude?(case_study)}
  end

  def agency_where_query
    "funnel_pages.agency_id = #{current_agency.id} OR funnel_pages.agency_id IS NULL"
  end

  def search_query
    return '' if params[:q].blank?

    "lower(industries.title) ILIKE '%#{params[:q]}%'"
  end

  def search_query_case_study
    return '' if params[:q].blank?

    "lower(case_studies.title) ILIKE '%#{params[:q]}%'"
  end

  def agency_niche_params
    params.require(:agency_niche).permit(:lead_form)
  end
end
