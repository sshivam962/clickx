# frozen_string_literal: true

class Public::ROICalculatorController < PublicController
  before_action :set_agency
  before_action :verify_action
  layout 'roi_calculator'

  def index
    @header = params[:header].eql?('false') ? false : true
  end

  private

  def set_agency
    @agency = Agency.find_by(name_slug: params[:agency_slug])
  end

  def verify_action
    return if @agency.present?

    redirect_to ENV['PUBLIC_APP_DOMAIN']
  end
end
