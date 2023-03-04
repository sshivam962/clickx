# frozen_string_literal: true

namespace :documents_faker do
  desc 'Keep updated at between 1-2 weeks ago'
  task change_updated_at: :environment do
    Document.where('updated_at < ?', 2.weeks.ago).each do |document|
      document.update(updated_at: rand(2.weeks.ago..Time.now))
    end
  end
end
