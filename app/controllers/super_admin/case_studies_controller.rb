# frozen_string_literal: true

class SuperAdmin::CaseStudiesController < ApplicationController
  layout :resolve_layout
  before_action :perform_authorization
  before_action :set_case_study, only: %i[edit update destroy preview published set_assignee]
  before_action :super_admins, only: %i[edit new index]

  def index
    @case_studies =
      CaseStudy.includes(:industries)
               .where(filter_query)
               .where(search_query)
               .with_service(params[:service])
               .order(params[:sort_by].presence || :title)
               .paginate(page: params[:page], per_page: 20)
  end

  def new
    @case_study = CaseStudy.new
  end

  def create
    @case_study = CaseStudy.new(case_study_params)

    if @case_study.save
      @case_study.published! if params[:publish].present?
      flash[:success] = 'CaseStudy updated Successfully'
      redirect_to super_admin_case_studies_path
    else
      flash[:error] = @case_study.errors.full_messages.to_sentence
      redirect_to new_super_admin_case_study_path(@case_study)
    end
  end

  def edit; end

  def update
    if @case_study.update(case_study_params)
      @case_study.published! if params[:publish].present?
      @case_study.draft! if params[:draft].present?

      flash[:success] = 'CaseStudy updated Successfully'
      redirect_to super_admin_case_studies_path
    else
      flash[:error] = @case_study.errors.full_messages.to_sentence
      redirect_to edit_super_admin_case_study_path(@case_study)
    end
  end

  def destroy
    @case_study.destroy
    redirect_to super_admin_case_studies_path
  end

  def preview
    @agency = Agency.find_by(name: 'OneIMS')
    render 'public/case_studies/show'
  end

  def published
    if @case_study.status == "published"
      @case_study.update(status:"draft")
    elsif @case_study.status == "draft"
      @case_study.update(status:"published")
    end
    redirect_to super_admin_case_studies_path
  end

  def set_assignee
    @case_study.update(assignee_id: params[:assignee_id].to_i)
  end

  private

  def super_admins
    @super_admins = User.where(role: 'admin').with_role(:case_studies)
  end

  def case_study_params
    params.require(:case_study).permit(
      :title, :description, :detailed_description, :descriptive_image, :in_their_words,
      :stat1_text, :stat1_value, :stat2_text, :stat2_value, :stat3_text, :stat3_value, :assignee_id,
      :tier, :internal_note, :short_desc, services: [],
      images_attributes: [:id, :file, :_destroy], industry_ids: []
    )
  end

  def filter_query
    query = {}
    query[:industries] = { id: params[:industry] } if params[:industry].present?
    query[:status] = params[:status] if params[:status].present?
    query[:assignee] = params[:assignee] if params[:assignee].present?
    query
  end

  def search_query
    return '' if params[:title].blank?

    "(lower(case_studies.title) ILIKE '%#{params[:title]}%')"
  end

  def set_case_study
    @case_study = CaseStudy.find(params[:id])
  end

  def perform_authorization
    authorize %i[super_admin case_study]
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
