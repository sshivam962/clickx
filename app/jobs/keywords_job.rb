# frozen_string_literal: true

class KeywordsJob < ApplicationJob
  include AuthorityLabs
  include SuckerPunch::Job

  def perform(keyword, engine, type)
    add_to_priority_queue(
      keyword.name,
      engine: engine,
      geo: keyword.city,
      type: type,
      locale: keyword.locale
    )
  end
end
