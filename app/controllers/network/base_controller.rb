# frozen_string_literal: true

class Network::BaseController < ApplicationController
  before_action :check_agreement_signed

  layout 'network'

  private

  def check_agreement_signed
    redirect_to network_sign_agreement_path unless current_user.network_profile&.agreement_signed?
  end
end
