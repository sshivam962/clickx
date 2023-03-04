# frozen_string_literal: true

class SuperAdmin::ChapterPolicy < ApplicationPolicy

  def new?
    can_manage?
  end

  def edit?
    can_manage?
  end

  def create?
    can_manage?
  end

  def update?
    can_manage?
  end

  def destroy?
    can_manage?
  end

  def update_position?
    can_manage?
  end

  def can_manage?
    agency_academy? || client_academy?
  end
end
