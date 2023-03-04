class SubscriptionResponseMailer < ApplicationMailer
  layout false

  def agency_non_growth(data)
    @package = data[:package]
    @package_name = @package[:package_name].humanize
    @agency = data[:agency]
    @user = data[:user]
    @banner_url = banner_url
    mail(from: 'Clickx<support@clickx.io>',
         to: [@user.email],
         bcc: ["andy@oneims.com", 'solomon@oneims.com', 'partners@clickx.io'],
         subject: 'Congrats 🎉')
  end

  private

  def banner_url
    banner_index = (@agency.non_growth_subscriptions.count % SUBSCRIPTION_RESPONSE_BANNERS.size)
    if banner_index.eql?(0)
      SUBSCRIPTION_RESPONSE_BANNERS.last
    else
      SUBSCRIPTION_RESPONSE_BANNERS[banner_index - 1]
    end
  end
end
