ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.testing? || Rails.env.development? || Rails.env.staging?
