# frozen_string_literal: true

class WebpushSubscriptionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    subscription = WebpushSubscription.find_or_create_by(endpoint: webpush_params[:subscription][:endpoint],
                                                         p256dh: webpush_params[:subscription][:keys][:p256dh],
                                                         auth: webpush_params[:subscription][:keys][:auth],
                                                         user: current_user)
    if subscription.valid?
      render json: subscription
    else
      render json: { status: :failed, data: subscription.errors }, status: :unprocessable_entity
    end
  end

  private

  def webpush_params
    params.permit(:message, subscription: [:endpoint, keys: %i[p256dh auth]])
  end
end
