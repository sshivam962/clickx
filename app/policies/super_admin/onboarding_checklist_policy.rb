# frozen_string_literal: true

class SuperAdmin::OnboardingChecklistPolicy < ApplicationPolicy

  def index?
    can_manage?
  end

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

  def sort_position?
    can_manage?
  end

  def create_checklist?
    can_manage?
  end

  def update_checklist?
    can_manage?
  end

  def delete_checklist?
    can_manage?
  end

  def can_manage?
    onboarding_checklists?
  end
end
