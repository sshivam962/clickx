# frozen_string_literal: true

class SuperAdmin::AgencyPolicy < ApplicationPolicy

  def archived?
    archived_agencies?
  end

  def unarchive?
    archived_agencies?
  end

  def agency_sheet?
    can_manage?
  end

  def force_delete?
    can_manage?
  end

  def index?
    can_manage?
  end

  def show?
    can_manage?
  end

  def download?
    can_manage?
  end

  def profile?
    can_manage?
  end

  def new?
    super_admin?
  end

  def edit?
    can_manage?
  end

  def change_agency_status?
    can_manage?
  end

  def invite_admin?
    can_manage?
  end

  def create?
    super_admin?
  end

  def update?
    can_manage?
  end

  def destroy?
    can_manage?
  end

  def get_businesses?
    can_manage?
  end

  def get_users?
    can_manage?
  end

  def check_user?
    can_manage?
  end

  def agency_admins?
    can_manage?
  end

  def add_client?
    can_manage?
  end

  def update_client?
    can_manage?
  end

  def destroy_client?
    can_manage?
  end

  def add_keywords?
    can_manage?
  end

  def get_agency_limits?
    can_manage?
  end

  def verify_cname?
    can_manage?
  end

  def update_home_link?
    can_manage? || agency_package_subscriptions?
  end

  def manage_growth_subscription?
    can_manage?
  end

  def downgrade_plan?
    can_manage?
  end

  def verified_domains?
    can_manage? || verified_domains_agencies?
  end

  def approve_signup?
    can_manage?
  end

  def scale_zoom?
    can_manage?
  end

  def update_scale_zoom_weeks?
    can_manage?
  end

  def can_manage?
    agencies?
  end
end
