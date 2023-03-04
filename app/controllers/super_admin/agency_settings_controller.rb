class SuperAdmin::AgencySettingsController < ApplicationController
  layout 'base'

  def index; end

  def update
    Setting::AGENCY_SETTINGS.each do |var|
      Setting.find_or_create_by(var: var).update(value: setting_params[var])
    end
  end

  private

  def setting_params
    params.require(:setting).permit(Setting::AGENCY_SETTINGS)
  end
end
