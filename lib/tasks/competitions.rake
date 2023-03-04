# frozen_string_literal: true

namespace :competitions do
  desc 'Update competitors with missing info'
  task update_info: :environment do
    Competition.find_each do |competitor|
      competitor.competition_update_job if competitor.info_missing?
    end
  end
end
