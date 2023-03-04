# frozen_string_literal: true

class Network::CaseStudiesController < Network::BaseController
  before_action :set_industry, only: %i[index show]
  before_action :set_case_study, only: %i[show edit update destroy]

  def index
    fetch_my_case_studies
  end

  def new
    @case_study = CaseStudy.new
  end

  def create
    @case_study = current_user.network_profile.case_studies.create(case_study_params)

    if @case_study.persisted?
      @case_study.published! if params[:publish].present?
      flash[:success] = 'Casestudy added Successfully'
      redirect_to network_profile_path
    else
      flash[:error] = @case_study.errors.full_messages.to_sentence
      redirect_to new_network_case_study_path(@case_study)
    end
  end

  def edit; end

  def update
    if @case_study.update(case_study_params)
      @case_study.published! if params[:publish].present?
      @case_study.draft! if params[:draft].present?

      flash[:success] = 'CaseStudy updated Successfully'
      redirect_to network_profile_path
    else
      flash[:error] = @case_study.errors.full_messages.to_sentence
      redirect_to edit_network_case_study_path(@case_study)
    end
  end

  def show
    @case_studies =
      CaseStudy.where(industry_id: @case_study.industry_id).order(:updated_at)
    index_of_current = @case_studies.ids.index(@case_study.id)
    @next = (@case_studies + @case_studies)[index_of_current + 1]
    @previous = (@case_studies + @case_studies)[index_of_current - 1]
  end

  def destroy
    @case_study.destroy
    redirect_to network_profile_path
  end

  private

  def fetch_my_case_studies
    @my_case_studies = @industry.case_studies.where(network_profile_id: current_user.network_profile.id).order(created_at: :desc)
  end

  def set_industry
    @industry = Industry.find(params[:industry_id])
  end

  def set_case_study
    @case_study = CaseStudy.find(params[:id])
  end

  def case_study_params
    params.require(:case_study).permit(
      :title, :description, :detailed_description, :descriptive_image,
      :stat1_text, :stat1_value, :stat2_text, :stat2_value, :stat3_text, :stat3_value, :assignee_id, :network_profile_id,
      :tier, :short_desc, services: [],
      images_attributes: [:id, :file, :_destroy], industry_ids: []
    )
  end
end
