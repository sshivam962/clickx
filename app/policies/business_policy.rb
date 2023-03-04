# frozen_string_literal: true

class BusinessPolicy
  attr_reader :user, :business

  def initialize(user, business)
    @user = user
    @business = business
  end

  def client_level_manage?
    business.user_ids.include?(user.id) ||
      user.ownable == business ||
      business.dummy? ||
      user.super_admin?
  end

  def visible?
    user.agency_admin? && business.agency.user_ids.include?(user.id) ||
      business.user_ids.include?(user.id) || user.super_admin? || business.dummy?
  end

  def manage?
    user.super_admin? || (user.agency_admin? && business.agency.user_ids.include?(user.id)) ||
      business.dummy?
  end

  def system_super_admin_action?
    user.super_admin? && user.clickx_admin?
  end
end
