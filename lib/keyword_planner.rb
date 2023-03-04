# frozen_string_literal: true
module KeywordPlanner
  CODE_TYPE = 'adword_keyword_planner'

  module_function

  def related_keywords(query)
    token = Token.find_by(code_type: CODE_TYPE)

    adword_client = AdwordsAuth.adword_client
    AdwordsAuth.set_credentials(adword_client, token.attributes, token.sub)
    api_client = adword_client.service(:TargetingIdeaService, AdwordsAuth::API_VERSION)

    selector = { idea_type: 'KEYWORD', request_type: 'IDEAS' }
    selector[:requested_attribute_types] = %w[
      KEYWORD_TEXT
      SEARCH_VOLUME
      AVERAGE_CPC
    ]
    selector[:paging] = {
      start_index: 0,
      number_results: 10
    }

    selector[:search_parameters] = []
    selector[:search_parameters] << {
      xsi_type: 'RelatedToQuerySearchParameter',
      queries: [query]
    }
    resp = api_client.get(selector)

    parse_response(resp)
  end

  def parse_response(resp)
    resp[:entries].map do |res|
      data = res[:data]
      {
        keyword_phrase: data["KEYWORD_TEXT"][:value],
        search_volume: data["SEARCH_VOLUME"][:value]
      }
    end
  end
end
