# frozen_string_literal: true

class Agency::CaseStudiesController < Agency::BaseController
  before_action :perform_authorization
  before_action :set_industry, only: %i[index show favorite unfavorite]
  before_action :set_case_study, only: %i[show favorite unfavorite edit update destroy]
  before_action :ensure_access, only: :show


  def index
    @my_case_study = 0
    if params[:my_case_study] == "1"
      fetch_my_case_studies
      @my_case_study = 1
    else
      fetch_favorite_case_studies
      fetch_remaining_case_studies
    end
    @agency_active_package_name = current_agency.active_package_name

    @agency_niche = AgencyNiche.find_or_create_by(
      agency_id: current_agency.id,
      industry_id: @industry.id
    )
  end

  def categories
    my_case_studies

    @cs_counts = {}
    CaseStudy::CATEGORIES.each do |c|
      @cs_counts[c[:key]] = CaseStudy.send(c[:key]).joins(:images).distinct.count
    end
  end

  def category_case_studies
    @category = CaseStudy::CATEGORIES.detect do |c|
      c[:id] == params[:category_id].to_i
    end || CaseStudy::CATEGORIES.first

    @case_studies =
      CaseStudy.includes(:industries)
               .send(@category[:key])
               .where(search_query)
               .priority_order
               .joins(:images).distinct
               .paginate(page: params[:page], per_page: 20)

    @agency_active_package_name = current_agency.active_package_name
  end

  def new
    @case_study = CaseStudy.new
  end

  def create
    @case_study = CaseStudy.new(case_study_params)

    if @case_study.save
      @case_study.published! if params[:publish].present?
      flash[:success] = 'Casestudy added Successfully'
      redirect_to agency_case_study_categories_path
    else
      flash[:error] = @case_study.errors.full_messages.to_sentence
      redirect_to new_agency_case_study_path(@case_study)
    end
  end

  def edit; end

  def update
    if @case_study.update(case_study_params)
      @case_study.published! if params[:publish].present?
      @case_study.draft! if params[:draft].present?

      flash[:success] = 'CaseStudy updated Successfully'
      redirect_to agency_case_study_categories_path
    else
      flash[:error] = @case_study.errors.full_messages.to_sentence
      redirect_to edit_agency_case_study_path(@case_study)
    end
  end

  def show
    @my_case_study = params[:my_case_study]
    @category_id = params[:category_id]
    @case_studies =
      CaseStudy.where(industry_id: @case_study.industry_id).order(:updated_at)
    index_of_current = @case_studies.ids.index(@case_study.id)
    @next = (@case_studies + @case_studies)[index_of_current + 1]
    @previous = (@case_studies + @case_studies)[index_of_current - 1]
  end

  def favorite
    if current_user.favorited_case_studies.include?(@case_study)
      current_user.favorite_case_studies.where(case_study_id: @case_study.id).destroy_all
      @favorite = false
    else
      current_user.favorited_case_studies << @case_study
      @favorite = true
    end
    @agency_active_package_name = current_agency.active_package_name
    fetch_favorite_case_studies
    fetch_remaining_case_studies
  end

  def create_agency_niche
    params[:industry_ids]&.each do |industry_id|
      @agency_niche = AgencyNiche.find_or_create_by(
        agency_id: current_agency.id,
        industry_id: industry_id
      )
    end
  end

  def destroy
    @case_study.destroy
    redirect_to agency_case_study_categories_path
  end

  private

  def fetch_favorite_case_studies
    @case_studies = @industry.case_studies.published.where(search_query).order(created_at: :desc)

    @fav_case_studies = @case_studies.select do |case_study|
      case_study if current_user.favorited_case_studies.include?(case_study) && case_study.images.count.positive?
    end
  end

  def fetch_remaining_case_studies
    @case_studies = @industry.case_studies.published.where(search_query).order(created_at: :desc)

    @rem_case_studies = @case_studies.select do |case_study|
      case_study if current_user.favorited_case_studies.exclude?(case_study) && case_study.images.count.positive?
    end
  end

  def set_industry
    @industry = Industry.find(params[:industry_id])
  end

  def set_case_study
    @case_study = CaseStudy.find(params[:id])
  end

  def perform_authorization
    authorize current_agency, :case_study?
  end

  def ensure_access
    return true if @case_study.has_access?(current_agency.active_package_name)

    redirect_to agency_case_studies_path(
      industry_id: @industry.id
    ) and return
  end

  def search_query
    return '' if params[:name].blank?

    "lower(case_studies.title) ILIKE '%#{params[:name]}%'"
  end

  def fetch_my_case_studies
    @case_studies = @industry.case_studies.published.where(search_query).order(created_at: :desc)

    @my_case_studies = @case_studies.select do |case_study|
      case_study if case_study.agency_id == current_agency.id && case_study.images.count.positive?
    end
  end

  def my_case_studies
    @my_case_studies = CaseStudy.includes(:industries).where(
      case_studies: { agency_id: current_agency.id }
    ).priority_order.paginate(page: params[:page], per_page: 20)
  end

  def case_study_params
    params.require(:case_study).permit(
      :title, :description, :detailed_description, :descriptive_image, :in_their_words,
      :stat1_text, :stat1_value, :stat2_text, :stat2_value, :stat3_text, :stat3_value, :assignee_id, :agency_id,
      :tier, :short_desc, services: [],
      images_attributes: [:id, :file, :_destroy], industry_ids: []
    )
  end
end
