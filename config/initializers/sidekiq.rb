Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Sidekiq::Throttler, storage: :redis
    chain.add Sidekiq::Status::ServerMiddleware, expiration: 30.minutes # default
  end
end
