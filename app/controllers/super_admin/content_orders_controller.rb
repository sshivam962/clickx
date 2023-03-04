class SuperAdmin::ContentOrdersController < ApplicationController
  layout 'base'
  before_action :get_business, only: %i[create]
  before_action :set_content_order

  def show
    @writer_form = WriterForm.data
  end

  def place_order_admin
    authorize @content_order.business, :client_level_manage?
    resp = WriterAccess.create_order @content_order.form_data
    if resp[0]
      @content_order.content_order_id = resp[0]['id']
      @content_order.save
      render json: { status: 200,
                     message: 'Content ordered successfully' }
    else
      render json: { status: 404,
                     message: 'Order unsuccessful, check order details' }
    end
  end

  private

  def get_business
    @business = Business.find params[:business_id]
  end

  def set_content_order
    @content_order = ContentOrder.find(params[:id])
  end
end
