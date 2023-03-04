# frozen_string_literal: true

class AddToDelayedQueueJob
  include AuthorityLabs
  include Sidekiq::Worker

  sidekiq_options throttle: {
    threshold: AuthorityLabs::DELAYED_REQUEST_LIMIT,
    period: 5.minutes,
    key: 'delayed_queue_key_word'
  }, queue: 'kw_delayed_queue'

  def perform(name, engine, city, type, locale = 'en-us')
    add_to_delayed_queue(
      name,
      engine: engine,
      geo: city,
      type: type,
      locale: locale
    )
  end
end
