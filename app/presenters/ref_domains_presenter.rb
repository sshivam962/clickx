# frozen_string_literal: true
class RefDomainsPresenter
  def initialize(model)
    @model = model
  end

  def referring_domains
    @model['Domain'].presence || 'NA'
  end

  def primary_topical_tf
    "[#{trust_value}] #{trust_topic}"
  end

  def trust_topic
    @model['TopicalTrustFlow_Topic_0'].presence
  end

  def trust_value
    @model['TopicalTrustFlow_Value_0'].presence
  end

  def backlinks
    @model['ExtBackLinks'].presence || 'NA'
  end

  def alexa_rank
    @model['AlexaRank'] < 1 ? 'N/A' : @model['AlexaRank']
  end

  def trust_flow
    @model['TrustFlow'].presence || 'NA'
  end

  def citation_flow
    @model['CitationFlow'].presence || 'NA'
  end
end
