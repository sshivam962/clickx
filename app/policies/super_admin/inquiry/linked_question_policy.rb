# frozen_string_literal: true

class SuperAdmin::Inquiry::LinkedQuestionPolicy < ApplicationPolicy
  def new?
    can_manage?
  end

  def create?
    can_manage?
  end

  def change_position?
    can_manage?
  end

  def can_manage?
    client_questionnaire?
  end
end
