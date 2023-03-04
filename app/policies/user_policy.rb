# frozen_string_literal: true

class UserPolicy
  attr_reader :current_user, :user
  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def can_destroy?
    current_user.super_admin? || admin_of_users_business? ||
    current_user.agency_admin?
  end

  def manage?
    current_user.super_admin?
  end

  private

  def admin_of_users_business?
    return false unless current_user.company_admin?
    user_in_the_ownable_business? || user_in_the_managable_businesses?
  end

  def user_in_the_ownable_business?
    return false unless current_user.ownable
    current_user.ownable.user_ids.include?(user.id)
  end

  def user_in_the_managable_businesses?
    return false if user.businesses.blank?
    user.businesses.flat_map(&:users).pluck(:id).include?(user.id)
  end
end
