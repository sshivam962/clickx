# frozen_string_literal: true

class Public::FreshteamWebhooksController < PublicController
  def callback
    candidate = ContractorsInvite.find_or_initialize_by(email: params['data']['email'])

    job_shortcode = [
      params['data']['job']['title'],
      params['data']['job']['location']
    ].join(' - ')
    candidate.tap do |c|
      c.first_name = params['data']['first_name']
      c.last_name = params['data']['last_name']
      c.email = params['data']['email']
      c.url = params['data']['url']

      c.shortcode = job_shortcode
      c.source = 'freshteam'
    end
    candidate.save

    job = WorkableJob.find_or_initialize_by(shortcode: candidate.shortcode)
    unless job.persisted?
      job.id = job_shortcode
      job.full_title = params['data']['job']['title']
      job.department = params['data']['job']['department']
      job.shortcode = job_shortcode
      job.save
    end
  end
end
