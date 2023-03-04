# frozen_string_literal: true

class Agency::ROICalculatorController < Agency::BaseController
	before_action :perform_authorization

  def index; end

  def show; end

  def roi_ecom_calculator; end

  def perform_authorization
    authorize current_agency, :roi?
  end
end
