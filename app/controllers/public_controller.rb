# frozen_string_literal: true

class PublicController < ActionController::Base
  before_action :set_raven_context
  # before_action :host_constraint_check
  after_action :allow_iframe

  layout 'plain'

  private

  def set_raven_context
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end

  def host_constraint_check
    return if HOST_CONSTRAINTS[request.host]&.include?(params[:controller])

    redirect_to ENV['PUBLIC_APP_DOMAIN']
  end
end
