# frozen_string_literal: true

class SuperAdmin::AdminUserPolicy < ApplicationPolicy
  def index?
    can_manage?
  end

  def new?
    can_manage?
  end

  def update?
    can_manage?
  end

  def destroy?
    can_manage?
  end

  def archived?
    archived_users?
  end

  def unarchive?
    archived_users?
  end

  def force_delete?
    can_manage?
  end

  private

  def can_manage?
    super_admin?
  end
end
