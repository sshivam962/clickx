# frozen_string_literal: true

module Subscription
  class CouponsController < ApplicationController
    before_action :set_coupon, only: :destroy

    def index
      render json: { status: 200, coupons: Subscription::Coupon.all }
    end

    def create
      @coupon = Subscription::Coupon.new(coupon_model_params)
      if @coupon.valid?
        Stripe::Coupon.create(stripe_coupon_params)
        @coupon.save
        render json: { status: 200, message: 'Coupon created successfully.' }
      else
        render json: { status: 406,
                       errors: @coupon.errors.full_messages.to_sentence }
      end
    end

    def destroy
      stripe_coupon = Stripe::Coupon.retrieve(@coupon.coupon_id)
      resp = stripe_coupon.delete
      @coupon.destroy if resp.deleted

      render json: { status: 200, message: 'Coupon deleted successfully.' }
    end

    private

    def set_coupon
      @coupon ||= Subscription::Coupon.find(params[:id])
    end

    def coupon_model_params
      @new_coupon_params ||=
        params.require(:coupon)
              .permit(:coupon_id, :duration, :amount_off, :currency,
                      :duration_in_months, :max_redemptions, :percent_off,
                      :redeem_by)
    end

    def stripe_coupon_params
      @stripe_params ||= coupon_model_params
      @stripe_params[:id] = @stripe_params[:coupon_id]
      if @stripe_params[:redeem_by].present?
        @stripe_params[:redeem_by] =
          DateTime.strptime(@stripe_params[:redeem_by], '%m/%d/%Y').to_i
      end

      @stripe_params.except(:coupon_id)
    end
  end
end
