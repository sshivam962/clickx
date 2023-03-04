require 'google/apis'
require 'google/apis/core/api_command'

Google::Apis::Core::ApiCommand.class_eval do
  def decode_response_body(content_type, body)
    body
  end
end
