# frozen_string_literal: true

class CustomUrlsController < ApplicationController
  before_action :set_business, only: %i[index create]
  before_action :set_custom_url, only: %i[update destroy]
  before_action -> { authorize @business, :client_level_manage? }, only: %i[index create]
  before_action -> { authorize @custom_url.business, :client_level_manage? }, only: %i[update destroy]
  def index
    custom_urls = @business.custom_urls.all.order(created_at: :desc)
    @custom_url = custom_urls.map { |custom_url| UrlBuilderPresenter.new(custom_url) }
    respond_to do |format|
      format.pdf do
        render pdf: 'custom_url_export.pdf',
               print_media_type: true
      end
      format.json { render json: { code: 200, data: custom_urls } }
    end
  end

  def create
    @custom_url = @business.custom_urls.new(custom_url_params)
    if @custom_url.save
      render json: { code: 200, data: @custom_url }
    else
      render json: { code: 406, data: @custom_url,
                     message: @custom_url.errors.full_messages.to_sentence }
    end
  end

  def destroy
    if @custom_url.destroy
      render json: { code: 200, message: 'Url deleted Successfully' }
    else
      render json: { code: 406, data: @custom_url,
                     message: @custom_url.errors.full_messages.to_sentence }
    end
  end

  def update
    if @custom_url.update_attributes(custom_url_params)
      render json: { code: 200,
                     data: @custom_url,
                     message: 'Success' }
    else
      render json: { code: 406,
                     data: nil,
                     errors: @custom_url.errors.full_messages.to_sentence }
    end
  end

  private

  def custom_url_params
    params.require(:custom_url).permit(:website_url, :campaign_source, :campaign_medium, :campaign_name, :campaign_term, :campaign_content, :complete_url)
  end

  def set_business
    @business ||= Business.with_dummy.find(params[:business_id])
  end

  def set_custom_url
    @custom_url ||= CustomUrl.find(params[:id])
  end
end
