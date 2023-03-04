require 'adwords_api'
class SuperAdmin::IntegrationsController < ApplicationController
  layout 'base'

  def index
    @keyword_planner_token = Token.find_by(code_type: KeywordPlanner::CODE_TYPE)
    @hubspot_token = Token.find_by(code_type: Token::HubspotAccessToken)
  end
end
