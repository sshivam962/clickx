# frozen_string_literal: true

class FunnelNotifierMailer < ApplicationMailer
  layout false, :only => 'funnel_lead_create_mail'

  def funnel_lead_create_mail(lead_id, agency_id, niche_name='')
    @lead = ::Lead.find lead_id
    @agency = Agency.find agency_id
    @niche_name = niche_name
    @users = @agency.users.normal.pluck(:email).join(',')
    mail(from: 'Clickx<notifications@clickx.io>',
      to: @users,
      subject: "New Lead: #{@lead.first_name} #{@lead.last_name}")
  end  
end  
