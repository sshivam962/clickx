# frozen_string_literal: true

class RankingSeo
  include HTTParty
  base_uri 'https://api.clientseoreport.com/v3/feeds/ranking/campaign'
  headers 'Authorization' => 'Basic ' + ENV['SEO_AUTH_TOKEN']

  def initialize(service, options)
    @service = service
    @options = options.except('controller', 'action', 'format')
  end

  def get_data
    self.class.get("/#{@service}", query: @options)
  end
end
