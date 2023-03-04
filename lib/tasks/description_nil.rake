# frozen_string_literal: true

namespace :send_chapters do
  desc 'Send Course_chapters with no description to admin'
  task without_description: :environment do
    courses = Course.includes(:chapters)
                    .where(chapters: { description: [nil, ''] })
                    .where.not(chapters: { id: nil })
                    .order(:resource_type)
    DescriptionNilNotifier.no_description_chapters(courses).deliver_now
  end
end
