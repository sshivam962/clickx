class WorkableJob < ApplicationRecord
  has_many :contractors_invites,
           foreign_key: :shortcode,
           primary_key: :shortcode,
           dependent: :destroy,
           inverse_of: :workable_job

  def self.update!(params = {})
    paging = { 'next' => "#{Workable::BASE_URL}/jobs?" }
    while paging.present?
      resp = Workable.jobs(url: paging['next'], params: params)
      resp['jobs']&.each do |j|
        job = WorkableJob.find_or_initialize_by(id: j['id'])
        job.full_title = j['full_title']
        job.department = j['department']
        job.url = j['url']
        job.shortcode = j['shortcode']
        job.workable_created_at = Time.zone.parse(j['created_at'])
        job.save
      end
      paging = resp['paging']
    end
  end
end
