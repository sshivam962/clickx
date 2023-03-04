# frozen_string_literal: true

class Agency::FaqsController < Agency::BaseController
	before_action :perform_authorization

  def index; end

  def perform_authorization
    authorize current_agency, :faqs?
  end
end
