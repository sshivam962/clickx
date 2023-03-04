# frozen_string_literal: true

namespace :location do
  desc 'Create location review short url'
  task create_short_url: :environment do
    Location.all.map(&:save)
    Business.all.map(&:save)

    Location.where(short_url: EMPTY).each(&:create_review_short_url)
  end
end
