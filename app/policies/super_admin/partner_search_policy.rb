# frozen_string_literal: true

class SuperAdmin::PartnerSearchPolicy < ApplicationPolicy
  def index?
    can_manage?
  end

  private

  def can_manage?
    partner_search?
  end
end
