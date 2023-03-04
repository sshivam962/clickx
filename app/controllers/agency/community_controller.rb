# frozen_string_literal: true

class Agency::CommunityController < Agency::BaseController
  skip_before_action :agency_active_check, :active_agency?
  before_action :perform_authorization

  def index; end

  def perform_authorization
    authorize current_agency, :community?
  end
end
