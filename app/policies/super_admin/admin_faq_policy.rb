class SuperAdmin::AdminFaqPolicy < ApplicationPolicy

  def index?
    can_manage?
  end

  def can_manage?
    admin_faq?
  end
end
