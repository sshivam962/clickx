# frozen_string_literal: true

class AgenciesPolicy
  attr_reader :user

  def initialize(user, _scope = :agencies)
    @user = user
  end

  def visible?
    user.super_admin?
  end

  def manage?
    user.super_admin?
  end
end
