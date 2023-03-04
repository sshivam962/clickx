# frozen_string_literal: true

class SuperAdmin::CaseStudyImagePolicy < ApplicationPolicy
  def update_position?
    can_manage?
  end

  def can_manage?
    agency_academy? || client_academy?
  end
end
