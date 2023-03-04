# frozen_string_literal: true

class KeywordRankingExportsController < ApplicationController
  def index
    business = Business.find(params[:id])
    authorize @business, :client_level_manage?
    @data = Businesses::KeywordRanks.fetch(business)
    respond_to do |format|
      format.pdf do
        render pdf: 'keyword_export.pdf'
      end
      format.json { render json: @data }
    end
  end
end
