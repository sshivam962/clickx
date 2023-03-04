# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'KeywordRankings', type: :request do
  describe 'GET /keyword_rankings' do
    it 'authoritylabs_callback' do
      post authoritylabs_callback_path, params: { "status": 'success', "status_code": 200, "status_description": 'success', "keyword": 'redpanthers', "engine": 'google', "locale": 'en-us', "rank_date": '2017-12-09', "number_of_results": '97', "pages_from": 'false', "lang_only": 'false', "safe": 'on', "geo": '', "autocorrect": '', "ppl_id": '', "mobile": 'false', "user_agent": 'desktop', "papi_id": '15128061849497', "html_id": '127ae6e1cd4bae2a88121e97ea8d0fed/15128061853745', "json_callback": 'http://api.authoritylabs.com/keywords/get.json?keyword=redpanthers&rank_date=2017-12-09&locale=en-us&engine=google&pages_from=false&lang_only=false&geo=&autocorrect=&mobile=false&user_agent=desktop&ppl_id=&papi_id=15128061849497', "html_callback": 'http://api.authoritylabs.com/keywords/get.html?keyword=redpanthers&rank_date=2017-12-09&locale=en-us&engine=google&pages_from=false&lang_only=false&geo=&autocorrect=&mobile=false&user_agent=desktop&ppl_id=&html_id=127ae6e1cd4bae2a88121e97ea8d0fed/15128061853745&data_format=HTML' }

      expect(response).to have_http_status(200)
    end
  end
end
