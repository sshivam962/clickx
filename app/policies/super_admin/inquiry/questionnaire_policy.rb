# frozen_string_literal: true

class SuperAdmin::Inquiry::QuestionnairePolicy < ApplicationPolicy
  def index?
    can_manage?
  end

  def can_manage?
    client_questionnaire?
  end
end
