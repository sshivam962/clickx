# frozen_string_literal: true
class TopPagesPresenter
  def initialize(model)
    @model = model
  end

  def title
    model['Title'].presence || 'NA'
  end

  def page
    model['URL'].presence || 'NA'
  end

  def external_backlinks
    model['ExtBackLinks'].presence || 'NA'
  end

  def referring_domains
    model['RefDomains'].presence || 'NA'
  end

  def trust_flow
    model['TrustFlow'].presence || 'NA'
  end

  def citation_flow
    model['CitationFlow'].presence || 'NA'
  end

  def tropical_trust_flow_value
    model['TopicalTrustFlow_Value_0'].presence || 'NA'
  end

  def tropical_trust_flow_topic
    model['TopicalTrustFlow_Topic_0'].presence || 'NA'
  end

  def date
    model['Date'].presence || 'NA'
  end

  private

  attr_accessor :model
end
