# frozen_string_literal: true

class AddToPriorityQueueJob
  include AuthorityLabs
  include Sidekiq::Worker
  sidekiq_options throttle: {
    threshold: AuthorityLabs::PRIORITY_REQUEST_LIMIT,
    period: 5.minutes,
    key: 'priority_queue_key_word'
  }, queue: 'kw_priority_queue'

  def perform(name, engine, city, type, locale)
    add_to_priority_queue(
      name,
      engine: engine,
      geo: city,
      type: type,
      locale: locale
    )
  end
end
