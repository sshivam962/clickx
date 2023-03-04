class SuperAdmin::AgencySettingsPolicy < ApplicationPolicy

  def index?
    can_manage?
  end

  def update?
    can_manage?
  end

  private

  def can_manage?
    agency_settings?
  end
end
