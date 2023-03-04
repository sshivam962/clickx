# frozen_string_literal: true

class BusinessesPolicy
  attr_reader :user

  def initialize(user, _scop = :businesses)
    @user = user
  end

  def manage?
    user.super_admin?
  end

  def visible?
    user.super_admin?
  end
end
