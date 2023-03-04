# frozen_string_literal: true

class SuperAdmin::FunnelPagePolicy < ApplicationPolicy
  def create?
    can_manage?
  end

  def edit?
    can_manage?
  end

  def update?
    can_manage?
  end

  def destroy?
    can_manage?
  end

  def index?
    can_manage?
  end

  def new?
    can_manage?
  end

  def preview?
    can_manage?
  end

  private

  def can_manage?
    full_access? || funnel_pages?
  end
end
