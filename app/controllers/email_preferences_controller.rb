# frozen_string_literal: true

class EmailPreferencesController < ApplicationController
  def create
    authorize(agency_admin_business.business.agency, :manage?) if agency_admin_business
    EmailPreference.enable_for_feature(feature: email_preferences_params[:feature],
                                       enable: email_preferences_params[:enabled],
                                       user: user,
                                       agency_admin_business: agency_admin_business,
                                       key: email_preferences_params[:key])
    redirect_back fallback_location: '/', flash: { success: 'Successfully updated' }
  end

  def update
    authorize(agency_admin_business.business.agency, :manage?) if agency_admin_business
    @email_preference = EmailPreference.find(params[:id])
    @email_preference.update_attributes(enabled: email_preferences_params[:enabled])
    redirect_back fallback_location: '/', flash: { success: 'Successfully updated' }
  end

  private

  def agency_admin_business
    @agency_admin_business ||= AgencyAdminBusinessEmailPreference.find_by(id: params[:agency_admin_business_email_preference_id])
  end

  def user
    User.find_by(id: params[:user_id])
  end

  def email_preferences_params
    params.require(:email_preference).permit(:key, :enabled, :feature, :key,
                                             :agency_admin_business_email_preference_id,
                                             :user_id)
  end
end
