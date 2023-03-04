# frozen_string_literal: true
class UrlBuilderPresenter
  def initialize(model)
    @model = model
  end

  def campaign_name
    model.campaign_name.presence || 'NA'
  end

  def complete_url
    model.complete_url.presence || 'NA'
  end

  def campaign_source
    model.campaign_source.presence || 'NA'
  end

  private

  attr_accessor :model
end
