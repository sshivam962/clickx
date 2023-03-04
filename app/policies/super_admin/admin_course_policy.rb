class SuperAdmin::AdminCoursePolicy < ApplicationPolicy

  def index?
    can_manage?
  end

  def show?
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

  def can_manage?
    admin_academy?
  end
end
