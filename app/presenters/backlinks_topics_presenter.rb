# frozen_string_literal: true
class BacklinksTopicsPresenter
  def initialize(model)
    @model = model
  end

  def topical_trust_flow
    model['TopicalTrustFlow'].presence || 'NA'
  end

  def topic
    model['Topic'].presence || 'NA'
  end

  def links
    model['Links'].presence || 'NA'
  end

  def links_from_ref_domains
    model['LinksFromRefDomains'].presence || 'NA'
  end

  def ref_domains
    model['RefDomains'].presence || 'NA'
  end

  private

  attr_accessor :model
end
