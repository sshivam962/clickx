# frozen_string_literal: true

class PaymentDetailsController < ApplicationController
  def index
    @payment_details = PaymentDetail.where(business_id: params[:business_id])
    render json: { status: 200,
                   payment_details: @payment_details }
  end

  def show
    @payment_detail = PaymentDetail.find params[:id]
    render json: { status: 200,
                   data: @payment_detail }
  end

  def destroy
    @payment_detail = PaymentDetail.find params[:id]
    if @payment_detail.destroy
      render json: { status: 200,
                     message: 'Card deleted successfully' }
    else
      render json: { status: 404,
                     errors: @payment_detail.errors }
    end
  end

  def stripe_payment
    @payment_detail = PaymentDetail.new
    @content = ContentOrder.find params[:order_id]
    response = @payment_detail.process_payment params[:order_price],
                                               params[:description],
                                               params[:email],
                                               params[:card_token],
                                               params[:stripe_customer_id]
    if (response.class == Stripe::Charge) && (response.status == 'succeeded' || response.status == 'paid')
      @content.order_price = params[:order_price]
      @content.payment_status = 1
      if params[:card_info]
        @content.payment_information = params[:card_info]
      else
        PaymentDetail.where(stripe_customer_id: 'cus_9FL4yUXJjm9H3w').pluck(:card_info)
        @content.payment_information = PaymentDetail.where(stripe_customer_id: 'cus_9FL4yUXJjm9H3w')
                                                    .pluck(:card_info).first
      end
      @content.paid_on = Time.current
      Notifier.new_content_order(@content, current_user).deliver_now
      User.admins_mailing_list.each do |user|
        user.notifications.create(
          actor: current_user,
          target: @content,
          action: 'payment.new_content_order'
        )
      end
      @content.form_data['instructions'] += "<h4>Company Information: #{@content.form_data['company_information']}.</h4>"
      @content.form_data['instructions'] += "<h4>Target Audience: #{@content.form_data['target_audience']}.</h4>"
      @content.form_data['instructions'] += "<h4>Things to mention: #{@content.form_data['things_to_mention']}.</h4>"
      @content.form_data['instructions'] += "<h4>Things to avoid: #{@content.form_data['things_to_avoid']}.</h4>"
      @content.form_data.except!('company_information', 'target_audience', 'things_to_mention', 'things_to_avoid')
      resp = WriterAccess.create_order @content.form_data
      if resp[0]
        @content.content_order_id = resp[0]['id']
        @content.order_status = 2
      end
      @content.save
      if response.save_card == true
        @payment_detail.name = params[:name]
        @payment_detail.email = params[:email]
        @payment_detail.card_info = params[:card_info]
        @payment_detail.card_token = params[:card_token]
        @payment_detail.business_id = params[:business_id]
        @payment_detail.stripe_customer_id = response.stripe_customer_id
        @payment_detail.save
      end
      render json: { status: 200,
                     body: response.status }
    else
      @content.order_status = 0
      @content.save
      render json: { status: 404,
                     body: response.message }
    end
  end
end
