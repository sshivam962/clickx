# frozen_string_literal: true

class ContentOrderController < ApplicationController
  before_action :get_business, only: %i[create index]
  before_action -> { authorize @business, :client_level_manage? }, only: %i[create index]
  def index
    @content_orders = ContentOrder.where(business_id: @business.id)
    render json: { status: 200,
                   data: @content_orders }
  end

  def complete_orders
    authorize :businesses, :visible?
    @content_orders = ContentOrder.order(updated_at: :desc)
    render json: { status: 200,
                   data: @content_orders }
  end

  def place_order_admin
    @content_order = ContentOrder.find params[:id]
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

  def show
    @content_order = ContentOrder.find params[:id]
    render json: { status: 200,
                   data: @content_order }
  end

  def create
    @content_order = @business.content_orders.new(content_order_params)
    @content_order.user_id = current_user.id
    @content_order[:form_data][:projectname] = @business.name
    if @content_order.save
      if content_order_params[:order_status] == 0
        render json: { status: 201,
                       content: @content_order,
                       message: 'Saved as draft' }
      elsif content_order_params[:order_status] == 1
        @order_price = calculate_order_price content_order_params
        redirect_to stripe_payment_content_order_path(@content_order,
                                                      business_id: params[:business_id],
                                                      email: params[:stripeEmail],
                                                      card_info: params[:card_final_digits],
                                                      card_token: params[:stripeToken],
                                                      name: params[:name],
                                                      stripe_customer_id: params[:stripe_customer_id],
                                                      order_price: format('%.2f', @order_price),
                                                      order_id: @content_order.id,
                                                      description: "New content order-#{@content_order.id},#{@business.name}")

      end
    else
      render json: { status: 406,
                     content: @content_order,
                     errors: @content_order.errors }
    end
  end

  def destroy; end

  def edit; end

  def update
    @content_order = ContentOrder.find params[:id]
    authorize @content_order.business, :client_level_manage?
    if @content_order.update_attributes(content_order_params)
      if content_order_params[:order_status] == 0
        render json: { status: 201,
                       content: @content_order,
                       message: 'Saved as draft' }
      elsif content_order_params[:order_status] == 1
        stripe_payment_redirection @content_order
      end
    else
      render json: { status: 406,
                     content: @content_order,
                     errors: @content_order.errors }
    end
  end

  def calculate_article_price
    params[:paidreview] = params[:paidreview].to_i
    @article_price = WriterAccess.calculate_price params[:writer], params[:maxwords], 0
    if params[:paidreview] == 2
      @article_price_with_proofreading = WriterAccess.calculate_price params[:writer], params[:maxwords], 2
      @proofreading_cost = @article_price_with_proofreading - @article_price
      render json: { status: 200,
                     proof_reading_price: format('%.2f', @proofreading_cost),
                     article_price: format('%.2f', @article_price),
                     total_price: format('%.2f', @article_price_with_proofreading) }
    elsif params[:paidreview] == 0
      render json: { status: 200,
                     total_price: format('%.2f', @article_price) }
    end
  end

  def calculate_order_price(content_order_params)
    @writer_cost = WriterForm.data
    case content_order_params[:form_data][:writer]
    when 2
      @words_cost = @writer_cost.two_star_writer * content_order_params[:form_data][:maxwords]
    when 3
      @words_cost = @writer_cost.three_star_writer * content_order_params[:form_data][:maxwords]
    when 4
      @words_cost = @writer_cost.four_star_writer * content_order_params[:form_data][:maxwords]
    when 5
      @words_cost = @writer_cost.five_star_writer * content_order_params[:form_data][:maxwords]
    when 6
      @words_cost = @writer_cost.six_star_writer * content_order_params[:form_data][:maxwords]
    end
    @proofreading_cost = if content_order_params[:form_data][:paidreview] == 2
                           (content_order_params[:form_data][:maxwords].to_f / 2000) * @writer_cost.proofreading_cost
                         else
                           0
                         end
    @total_price = (@proofreading_cost + @words_cost) + (((@proofreading_cost + @words_cost) * @writer_cost.markup_percentage) / 100)
  end

  def form_data
    render json: { status: 200,
                   data: WriterForm.data }
  end

  def business_cards_list
    authorize Business.find(params[:business_id]), :client_level_manage?
    @payment_details = PaymentDetail.where(business_id: params[:business_id])
    render json: { status: 200,
                   payment_details: @payment_details }
  end

  private

  def get_business
    @business = Business.find params[:business_id]
  end

  def stripe_payment_redirection(content_order)
    @business = Business.find params[:business_id]
    authorize @business, :client_level_manage?
    @content_order = content_order
    @order_price = calculate_order_price content_order_params
    redirect_to stripe_payment_content_order_path(@content_order,
                                                  business_id: params[:business_id],
                                                  email: params[:stripeEmail],
                                                  card_info: params[:card_final_digits],
                                                  card_token: params[:stripeToken],
                                                  name: params[:name],
                                                  stripe_customer_id: params[:stripe_customer_id],
                                                  order_price: format('%.2f', @order_price),
                                                  order_id: @content_order.id,
                                                  description: "New content order-#{@content_order.id},#{@business.name}")
  end

  def content_order_params
    form_data_keys = params[:content_order][:form_data].keys
    params.require(:content_order).permit(:id, :business_id, :order_status,
                                          :payment_status, :payment_information, :paid_on, :writer, :maxwords,
                                          :paidreview, :stripeEmail, :stripeToken, :card_final_digits, :name,
                                          form_data: form_data_keys)
  end
end
