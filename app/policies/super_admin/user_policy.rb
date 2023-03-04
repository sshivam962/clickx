# frozen_string_literal: true

class SuperAdmin::UserPolicy < ApplicationPolicy
  def edit?
    can_manage?
  end

  def update?
    can_manage?
  end

  def destroy?
    can_manage?
  end

  def set_email_alert?
    can_manage?
  end

  def set_agency_super_admin?
    can_manage?
  end

  def resend_invitation?
    super_admin?
  end

  private

  def can_manage?
    full_access? || admin_users?
  end
end
