require "ruby/openai"
module Openai
  module_function

  def authorization_uri
    
    OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])

  end
end