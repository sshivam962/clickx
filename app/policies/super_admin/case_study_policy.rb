# frozen_string_literal: true

class SuperAdmin::CaseStudyPolicy < ApplicationPolicy
  def index?
    can_manage?
  end

  def new?
    can_manage?
  end

  def update?
    can_manage?
  end

  def edit?
    can_manage?
  end

  def create?
    can_manage?
  end

  def destroy?
    can_manage?
  end

  def published?
    can_manage?
  end

  def preview?
    can_manage?
  end

  def set_assignee?
    can_manage?
  end

  def can_manage?
    case_studies?
  end
end
