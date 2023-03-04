# frozen_string_literal: true

class DevelopmentMailInterceptor
  def self.delivering_email(message)
    if Rails.env.development?
      message.subject = "#{message.to} #{message.subject}"
      message.to = %w[dev@clickx.io]
      # elsif Rails.env.staging?
      # message.to = %w[dev+staging@clickx.io]
    end
  end
end
