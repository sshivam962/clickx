# frozen_string_literal: true

class Businesses::TagsController < ApplicationController
  before_action :set_business
  before_action :set_tag, only: %i[keywords destroy update]

  def tag_keywords
    keywords = Keyword.where(id: params[:business_keyword_ids])
    Keyword.transaction do
      if tag_params[:tags].present?
        @tags = Keywords::CreateTag.new(@business.id, tag_params[:tags]).run
      end
      keywords.each do |keyword|
        keyword.keyword_tags = @tags
        keyword.save!
      end
    end
    render json: { status: 200, tags: @tags }, status: :ok
  end

  def create
    tag = @business.keyword_tags.new(new_tag_params)
    if tag.save
      render json: { tag: tag }, status: :created
    else
      render json: tag.errors, status: :bad_request
    end
  end

  def index
    render json: {
      businesses_keyword_tags:
        @business
          .keyword_tags
          .left_joins(:keywords)
          .group(:id)
          .order("count(keywords.id) desc")
    }
  end

  def keywords
    render json: { data: latest_keyword_ranking, tag: @tag }
  end

  def untag_business_keyword
    keywords = Keyword.where(id: params[:biz_keyword_ids])
    untag(keywords)
    render json: { status: 200 }, status: :ok
  end

  def update
    @tag.update_attributes(tag_params)
    head :ok
  end

  def destroy
    untag(@tag.keywords)
    @tag.destroy!
    render json: { status: 200 }, status: :ok
  end

  private

  def new_tag_params
    params.require(:tag).permit(:name, :color)
  end

  def tag_params
    params.permit(tags: %i[name color id business_id])
  end

  def set_business
    @business ||=
      (Business.with_dummy.find_by(id: params[:id]) )
  end

  def set_tag
    @tag ||= KeywordTag.find_by(id: params[:tag_id])
  end

  def latest_keyword_ranking
    params[:limit] ||= 50
    Businesses::TagKeywords.fetch(@business, params)
  end

  def untag(keywords)
    keywords.each do |keyword|
      keyword.keyword_tag_id = nil
      keyword.save!
    end
  end
end
