# frozen_string_literal: true

class SuperAdmin::CustomPackagePolicy < ApplicationPolicy

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

  def load_businesses?
    can_manage?
  end

  def can_manage?
    custom_packages?
  end
end
