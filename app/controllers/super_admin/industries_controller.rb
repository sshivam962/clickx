# frozen_string_literal: true

class SuperAdmin::IndustriesController < ApplicationController
  layout 'base'
  before_action :perform_authorization
  before_action :set_industry, only: %i[edit update destroy]

  def index
    @industries = Industry.order(:title)
  end

  def new
    @industry = Industry.new
  end

  def create
    @industry = Industry.new(industry_params)
    if @industry.save
      flash[:success] = 'Industry updated Successfully'
      redirect_to super_admin_industries_path
    else
      flash[:error] = @industry.errors.full_messages.to_sentence
      redirect_to new_super_admin_industry_path(@industry)
    end
  end

  def edit; end

  def update
    if @industry.update(industry_params)
      flash[:success] = 'Industry updated Successfully'
      redirect_to super_admin_industries_path
    else
      flash[:error] = @industry.errors.full_messages.to_sentence
      redirect_to edit_super_admin_industry_path(@industry)
    end
  end

  def destroy
    if @industry.destroy
      flash[:success] = 'Industry deleted Successfully'
    else
      flash[:error] = @industry.errors.full_messages.to_sentence
    end
    redirect_to super_admin_industries_path
  end

  private

  def industry_params
    params.require(:industry).permit(:title, :icon_klass)
  end

  def set_industry
    @industry = Industry.find(params[:id])
  end

  def perform_authorization
    authorize %i[super_admin industry]
  end
end
