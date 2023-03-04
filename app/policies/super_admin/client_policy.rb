# frozen_string_literal: true

class SuperAdmin::ClientPolicy < ApplicationPolicy

  def questionnaires?
    client_package_subscriptions?
  end

  def archived?
    archived_clients?
  end

  def unarchive?
    archived_clients?
  end

  def client_sheet?
    can_manage?
  end

  def force_delete?
    user.super_admin?
  end

  def update_home_link?
    client_package_subscriptions?
  end

  def index?
    can_manage?
  end

  def destroy?
    can_manage?
  end

  def edit?
    can_manage?
  end

  def remove_user?
    super_admin?
  end

  def clear_yext_cache?
    can_manage?
  end

  def update?
    can_manage?
  end

  def update_customer?
    can_manage?
  end

  def add_subscription_account?
    can_manage?
  end

  def traction?
    clients?
  end

  def activities?
    can_manage?
  end

  def disconnect_semrush_project?
    can_manage?
  end

  def connect_semrush_project?
    can_manage?
  end

  private

  def can_manage?
    clients?
  end
end
