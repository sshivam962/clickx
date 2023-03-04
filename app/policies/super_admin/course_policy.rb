# frozen_string_literal: true

class SuperAdmin::CoursePolicy < ApplicationPolicy

  def index?
    can_manage?
  end

  def new?
    can_manage?
  end

  def show?
    can_manage?
  end

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

  def all?
    can_manage?
  end

  def preview?
    can_manage?
  end

  def load_chapter?
    can_manage?
  end

  def complete_chapter?
    can_manage?
  end

  def update_position?
    can_manage?
  end

  def scale_program?
    can_manage?
  end

  def create_action_step?
    can_manage?
  end

  def destroy_action_step?
    can_manage?
  end

  def move_up?
    can_manage?
  end

  def move_down?
    can_manage?
  end

  def can_manage?
    agency_academy? || client_academy? || admin_academy?
  end

  def department_wise_user?
    can_manage?
  end
end
