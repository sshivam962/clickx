# frozen_string_literal: true

class SuperAdmin::DocumentPolicy < ApplicationPolicy

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

  def can_manage?
    documents?
  end
end
