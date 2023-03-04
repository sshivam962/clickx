class SuperAdmin::CouponsController < ApplicationController
  layout 'base'
  before_action :set_coupon, only: :destroy

  def index
    @coupons = Subscription::Coupon.order(:created_at)
                                   .paginate(page: params[:page], per_page: 30)
  end

  def new
    @coupon = Subscription::Coupon.new
  end

  def create
    @coupon = Subscription::Coupon.new(coupon_params)
    if @coupon.valid?
      Stripe::Coupon.create(stripe_coupon_params)
      @coupon.save
      flash[:notice] = 'Coupon created successfully'
      redirect_to super_admin_coupons_path
    else
      flash[:error] = @coupon.errors.full_messages.to_sentence
      render :new
    end
  rescue Stripe::InvalidRequestError => e
    flash[:error] = e.json_body[:error][:message]
    render :new
  end

  def destroy
    stripe_coupon = Stripe::Coupon.retrieve(@coupon.coupon_id)
    resp = stripe_coupon.delete
    @coupon.destroy if resp.deleted
    flash[:notice] = 'Coupon deleted successfully.'
    redirect_to super_admin_coupons_path
  end

  private

  def set_coupon
    @coupon = Subscription::Coupon.find(params[:id])
  end

  def coupon_params
    params.require(:subscription_coupon).permit(
      :coupon_id, :duration, :amount_off, :currency,:duration_in_months,
      :max_redemptions, :percent_off, :redeem_by
    )
  end

  def stripe_coupon_params
    @stripe_params ||= coupon_params
    @stripe_params[:id] = coupon_params[:coupon_id]
    if @stripe_params[:redeem_by].present?
      @stripe_params[:redeem_by] =
        DateTime.strptime(coupon_params[:redeem_by], '%m-%d-%Y').to_i
    end

    if coupon_params[:amount_off].blank?
      @stripe_params.delete(:amount_off)
    else
      @stripe_params[:amount_off] =  @stripe_params[:amount_off].to_i * 100
    end

    if coupon_params[:percent_off].blank?
      @stripe_params.delete(:percent_off)
    else
      @stripe_params[:percent_off] =  @stripe_params[:percent_off].to_i
    end

    unless coupon_params[:duration].eql?('repeating')
      @stripe_params.delete(:duration_in_months)
    end

    if coupon_params[:max_redemptions].blank?
      @stripe_params.delete(:max_redemptions)
    end

    @stripe_params.except(:coupon_id).to_h
  end
end
