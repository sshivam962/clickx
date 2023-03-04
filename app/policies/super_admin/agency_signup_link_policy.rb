# frozen_string_literal: true

class SuperAdmin::AgencySignupLinkPolicy < ApplicationPolicy
  def index?
    can_manage?
  end

  def new?
    can_manage?
  end

  def create?
    can_manage?
  end

  def destroy?
    can_manage?
  end

  def update?
    can_manage?
  end

  def edit?
    can_manage?
  end

  def set_calendly?
    can_manage?
  end

  def calendly_script?
    can_manage?
  end

  def edit_admin_calendly_script?
    can_manage?
  end

  def update_admin_calendly_script?
    can_manage?
  end

  def delete_admin_calendly_script?
    can_manage?
  end

  def new_admin_calendly_script?
    can_manage?
  end

  def create_admin_calendly_script?
    can_manage?
  end

  def set_calendly_script?
    can_manage?
  end

  def can_manage?
    agency_signup_links?
  end
end
