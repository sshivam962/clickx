# frozen_string_literal: true

namespace :business_intelligence_cache do
  desc 'Update business Intelligence cache daily'
  task update: :environment do
    Business.find_each do |business|
      begin
        business.build_cache_for_intelligence
      rescue Exception => e
        Raven.capture_exception(e, extra: {location: 'Business Intelligence Cache Rake', Business: business.id})
      end
    end
  end
end
