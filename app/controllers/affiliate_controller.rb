# frozen_string_literal: true

class AffiliateController < ApplicationController
  layout 'themeX_base'

  def dashboard
    @agency_subscriptions =
      current_user.package_subscriptions.group_by { |m| m.created_at.beginning_of_month }
  end
end
