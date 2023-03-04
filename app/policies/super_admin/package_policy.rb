# frozen_string_literal: true

class SuperAdmin::PackagePolicy < ApplicationPolicy

  def index?
    can_manage?
  end

  def edit?
    can_manage?
  end

  def update?
    can_manage?
  end

  def preview?
    can_manage?
  end

  def checklist?
    can_manage?
  end

  def destroy_ensure_checklist?
    can_manage?
  end

  private

  def can_manage?
    packages?
  end
end
