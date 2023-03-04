# frozen_string_literal: true

class Business::CustomUrlsController < Business::BaseController
  before_action :set_business
  before_action :set_custom_url, only: %i[edit update destroy]
  before_action -> { authorize @business, :client_level_manage? }, only: %i[index create]
  before_action -> { authorize @custom_url.business, :client_level_manage? }, only: %i[update destroy]

  def index
    @custom_urls = @business.custom_urls.order(created_at: :desc)
  end

  def create
    @custom_url = @business.custom_urls.new(custom_url_params)
    @custom_url.complete_url = generate_complete_url

    if @custom_url.save
      @success = "Custom URL Successfully Created."
    else
      @error = @custom_url.errors.full_messages.to_sentence
    end

    redirect_to business_custom_urls_path
  end

  def edit; end

  def update
    if @custom_url.update(custom_url_params.merge(complete_url: generate_complete_url))
      @success = "Custom URL Successfully Updated."
    else
      @errors = @custom_url.errors.full_messages.to_sentence
    end

    redirect_to business_custom_urls_path
  end

  def destroy
    if @custom_url.destroy
      flash[:notice ] = "Custom URL Successfully Deleted."
      redirect_to business_custom_urls_path
    else
      flash[:alert] = @custom_url.errors.full_messages.to_sentence
    end
  end

  private

  def custom_url_params
    params.require(:custom_url).permit(
      :website_url, :campaign_source, :campaign_medium, :campaign_name,
      :campaign_term, :campaign_content, :complete_url
    )
  end

  def set_business
    @business = current_business
  end

  def set_custom_url
    @custom_url ||= CustomUrl.find(params[:id])
  end

  def generate_complete_url
    url_params = {}

    params[:custom_url].each do |key, value|
      if key.eql?("campaign_source") && value.present?
        url_params["utm_source"] = value
      elsif key.eql?("campaign_name") && value.present?
        url_params["utm_campaign"] = value
      elsif key.eql?("campaign_medium") && value.present?
        url_params["utm_medium"] = value
      elsif key.eql?("campaign_term") && value.present?
        url_params["utm_term"] = value
      elsif key.eql?("campaign_content") && value.present?
        url_params["utm_content"] = value
      end
    end

    params[:custom_url][:website_url] + "?" + url_params.to_query
  end
end
