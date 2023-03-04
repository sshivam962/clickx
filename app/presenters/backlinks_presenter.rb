# frozen_string_literal: true
class BacklinksPresenter
  def initialize(model)
    @model = model
  end

  def referring_page
    model['SourceURL'].presence || 'NA'
  end

  def title
    model['SourceTitle'].presence || 'NA'
  end

  def trust_flow
    model['SourceTrustFlow'].presence || 'NA'
  end

  def citation_flow
    model['SourceCitationFlow'].presence || 'NA'
  end

  def link_type
    model['LinkType'].presence || 'NA'
  end

  def first_indexed_date
    model['FirstIndexedDate'].presence || 'NA'
  end

  def last_seen_date
    model['LastSeenDate'].presence || 'NA'
  end

  def anchor_text
    model['AnchorText'].presence || 'NA'
  end

  private

  attr_accessor :model
end
