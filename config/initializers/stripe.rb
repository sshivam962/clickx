Rails.configuration.stripe = {
  publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'],
  secret_key: ENV['STRIPE_SECRET_KEY'],
  signing_secret: ENV['STRIPE_SIGNING_SECRET']
}

# Stripe.api_version = '2017-12-14'
Stripe.api_version = '2019-02-19'
Stripe.api_key = Rails.configuration.stripe[:secret_key]
StripeEvent.signing_secret = Rails.configuration.stripe[:signing_secret]

StripeEvent.configure do |events|
  events.all do |event|
    Rails.logger.info "[Stripe Webhook] #{event.type}"
  end
end
