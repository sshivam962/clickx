# frozen_string_literal: true

class SuperAdmin::SmbPackageSubscriptionPolicy < ApplicationPolicy

  def index?
    can_manage?
  end

  private

  def can_manage?
    smb_package_subscriptions?
  end
end
