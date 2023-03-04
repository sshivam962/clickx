require 'sucker_punch/async_syntax'
Rails.application.configure do
  config.active_job.queue_adapter = :sucker_punch
  # config.active_job.queue_adapter = :sidekiq
end
