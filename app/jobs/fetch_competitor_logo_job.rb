# frozen_string_literal: true

class FetchCompetitorLogoJob < ApplicationJob
  def perform(competitor)
    ActiveRecord::Base.connection_pool.with_connection do
      competitor.logo = Clearbit::Enrichment::Company.find(domain: competitor.name, stream: true).logo
      competitor.save
    end
  rescue StandardError => exception
    puts 'Invalid Domain'
  end
end
