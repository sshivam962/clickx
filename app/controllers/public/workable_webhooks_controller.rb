# frozen_string_literal: true

class Public::WorkableWebhooksController < PublicController
  def callback
    candidate = ContractorsInvite.with_deleted.find_by(email: params['data']['email'])
    candidate ||= ContractorsInvite.find_or_initialize_by(workable_id: params['data']['id'])
    candidate.tap do |c|
      c.workable_id = params['data']['id']
      c.first_name = params['data']['firstname']
      c.last_name = params['data']['lastname']
      c.phone = params['data']['phone']
      c.email = params['data']['email']
      c.created_by = params['data']['created_by']
      c.email_template_name = params['data']['email_template_name']
      c.shortcode = params['data']['job']['shortcode']
      c.workable_created_at = Time.zone.parse(params['data']['created_at'])
      c.workable_updated_at = Time.zone.parse(params['data']['updated_at'])
      c.source = 'workable'
    end
    candidate.save

    job = WorkableJob.find_or_initialize_by(shortcode: candidate.shortcode)
    unless job.persisted?
      workable_job = Workable.get_job(job.shortcode)
      job.id = workable_job['id']
      job.full_title = workable_job['full_title']
      job.department = workable_job['department']
      job.url = workable_job['url']
      job.shortcode = workable_job['shortcode']
      job.workable_created_at = Time.zone.parse(workable_job['created_at'])
      job.save
    end
  end
end
