# frozen_string_literal: true

class ContentOrderDefaultsController < ApplicationController
  def create
    @content_default = ContentOrderDefault.new(content_default_params)
    if @content_default.save
      render json: { status: 201,
                     data: @content_default,
                     message: 'Default values for content order saved successfully' }
    else
      render json: { status: 404,
                     errors: @content_default.errors }
    end
  end

  def update
    @content_default = ContentOrderDefault.find params[:id]
    if @content_default.update_attributes(content_default_params)
      render json: { status: 200,
                     data: @content_default,
                     message: 'Default values for content order saved successfully' }
    else
      render json: { sttus: 404,
                     errors: @content_default }
    end
  end

  # Get content_order_default object associated with a business.
  def default_by_business
    @content_default = ContentOrderDefault.where(business_id: params[:business_id]).first
    render json: { status: 200,
                   data: @content_default }
  end

  private

  def content_default_params
    params.require(:content_order_default).permit(:id, :business_id,
                                                  :company_information, :target_audience, :things_to_mention,
                                                  :things_to_avoid)
  end
end
