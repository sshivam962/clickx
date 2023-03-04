class CompetitorMailer < ApplicationMailer
  layout false
  def competitor_added(competitor, current_user)
    @competitor = competitor
    @business = competitor.business
    @current_user = current_user
    mail(
      from: 'Clickx<support@clickx.io>',
      to: ['solomon@clickx.io', 'sales@agencyservices.us'],
      subject: "Competitor Added: #{@competitor.name}")
  end
end
