# frozen_string_literal: true

class Businesses::IntelligenceController < ApplicationController
  before_action :set_business
  before_action -> { authorize @business, :client_level_manage? }
  before_action :set_intelligence

  before_action -> { stub_with_dummy_data(key: 'all') }, only: :all

  def contacts_per_day
    render json: { data: @intelligence[:contacts_per_day] }
  end

  def top_keywords
    render json: { data: @intelligence[:top_10_keywords] }
  end

  def new_contacts_by_source
    render json: { data: @intelligence[:new_contacts_by_source] }
  end

  def contacts_overview
    render json: { data: @intelligence[:contacts_overview] }
  end

  def best_performing_ads
    render json: { data: @intelligence[:best_performing_ads] }
  end

  def all
    render json: @intelligence
  end

  private

  def set_business
    @business = Business.with_dummy.find(params[:id])
  end

  def set_intelligence
    @business.build_cache_for_intelligence if @business.intelligence_cache.blank?
    @intelligence = @business.intelligence_cache
  end
end
