class SuperAdmin::EmailSentsController < ApplicationController
  layout 'base'

  def index
    interval = params[:email_sent_time_option].nil? ? 24 :  params[:email_sent_time_option].to_i
    agencies = Agency.all
    @data = []
    agencies.each do |agency|
      count = agency.sent_emails.where(updated_at: (Time.now - interval.hours)..Time.now).count
      if count.positive?
        @data << {agency_name: agency.name, count: count, remaining_limit: agency.outscraper_limit.credit_balance}
      end
    end

  end

end
