# frozen_string_literal: true

class Agency::ProfilesController < Agency::BaseController
  before_action :perform_authorization
  before_action :set_agency, only: %i[show update]

  def show; end

  def update
    profile = @agency.agency_profile
    profile.update_attributes(profile_params)
    if profile.errors.present?
      flash[:notice] = profile.errors.full_messages.to_sentence
    end
    redirect_to agency_profile_path
  end

  private

  def perform_authorization
    authorize current_agency, :profile?
  end

  def set_agency
    @agency = current_agency
  end

  def profile_params
    params.require(:agency_profile).permit(
      :estd_date, :core_services, :value_proposition, :preferred_niche,
      :niche_description, :niche_lookup_keyword, :customer_pain_points,
      :decision_makers, :niche_directories, :client_call_source, :challenges,
      :monthly_revenue, :monthly_revenue_goal
    )
  end
end
