# frozen_string_literal: true
class AnchorTextPresenter
  def initialize(model)
    @model = model
  end

  def anchor_text
    model.dig('AnchorText').presence || 'NA'
  end

  def topics
    model.dig('TopicalTrustFlow_Topic_0').presence || 'NA'
  end

  def referring_domains
    model.dig('RefDomains').presence || 'NA'
  end

  def total_links
    model.dig('TotalLinks').presence || 'NA'
  end

  def deleted_links
    model.dig('DeletedLinks').presence || 'NA'
  end

  def no_follow_links
    model.dig('NoFollowLinks').presence || 'NA'
  end

  def estimated_link_trust_flow
    model.dig('EstimatedLinkTrustFlow').presence || 'NA'
  end

  def estimated_link_citation_flow
    model.dig('EstimatedLinkCitationFlow').presence || 'NA'
  end

  private

  attr_accessor :model
end
