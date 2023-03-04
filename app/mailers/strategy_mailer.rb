# frozen_string_literal: true

class StrategyMailer < ApplicationMailer
  layout false

  def pending_approval strategy_id
    @strategy = Lead::Strategy.find(strategy_id)
    @lead = @strategy.lead
    mail(
      from: 'Clickx<support@clickx.io>',
      to: 'agunder@oneims.com',
      subject: "Lead Strategy Pending Approval - #{@lead.full_name}"
    )
  end

  def approved strategy_id, user_id
    @strategy = Lead::Strategy.find(strategy_id)
    @user = User.find(user_id)
    @lead = @strategy.lead
    mail(
      from: 'Clickx<support@clickx.io>',
      to: @user.email,
      subject: "Strategy for #{@lead.full_name} is Ready."
    )
  end
end
