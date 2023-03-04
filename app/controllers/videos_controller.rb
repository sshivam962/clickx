# frozen_string_literal: true

class VideosController < ApplicationController
  before_action :set_video, only: %i[show update destroy]
  def index
    render json: Video.order('LOWER(title)')
  end

  def create
    @video = Video.new(video_params)
    if @video.save
      render json: { status: 201, data: @video }
    else
      render json: { status: 406, data: @video,
                     errors: @video.errors.full_messages.to_sentence }
    end
  end

  def categories_list
    render json: Video.order(:category).pluck(:category).uniq.compact
  end

  def show
    render json: { status: 201, data: @video }
  rescue StandardError
    render json: { status: 406, errors: 'Video not Found' }
  end

  def update
    if @video.update_attributes(video_params)
      render json: { status: 201, data: @video }
    else
      render json: { status: 406, data: @video,
                     errors: @video.errors.full_messages.to_sentence }
    end
  end

  def destroy
    if @video.destroy
      render json: { status: 201 }
    else
      render json: { status: 406,
                     errors: @video.errors.full_messages.to_sentence }
    end
  end

  def academy
    if !params[:category].eql?('All')
      render json: Video.where(category: params[:category])
    else
      render json: Video.order('LOWER(category)')
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :description, :embed_code, :category)
  end

  def set_video
    @video ||= Video.find(params[:id])
  end
end
