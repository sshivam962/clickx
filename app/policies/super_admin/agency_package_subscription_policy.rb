# frozen_string_literal: true

class SuperAdmin::AgencyPackageSubscriptionPolicy < ApplicationPolicy

  def index?
    can_manage?
  end

  def more_info?
    can_manage?
  end

  def load_home_link?
    can_manage?
  end

  def new_op?
    can_manage?
  end

  def assign_op?
    can_manage?
  end

  def show_op?
    can_manage?
  end

  def update_op?
    can_manage?
  end

  def list_op?
    can_manage?
  end

  def cancel?
    can_manage?
  end

  def revert_cancel?
    can_manage?
  end

  private

  def can_manage?
    agency_package_subscriptions?
  end
end
