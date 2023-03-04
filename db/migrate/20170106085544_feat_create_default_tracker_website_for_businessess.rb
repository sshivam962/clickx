class FeatCreateDefaultTrackerWebsiteForBusinessess < ActiveRecord::Migration[4.2]
  def up
    Business.includes(:tracker_websites).where(tracker_websites: {id: nil}).find_each do |business|
      website = business.tracker_websites.build
      website.title = business.name
      website.uri = business.domain
      website.save
    end
  end
end
