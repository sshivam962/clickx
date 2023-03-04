# frozen_string_literal: true

class Business::BaseController < ApplicationController
  before_action :check_business_user?

  layout 'bu_themeX_base'

  def check_if_clickx_client?
    return true if current_business.agency.clickx?

    redirect_to root_url
  end

  def check_business_user?
    return true if current_user.business_user? && current_business.present?

    redirect_to root_url
  end
end
