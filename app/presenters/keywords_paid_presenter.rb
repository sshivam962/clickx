# frozen_string_literal: true

class KeywordsPaidPresenter
  def initialize(model)
    @model = model
  end

  def name
    model['keyword'].presence || 'NA'
  end

  def position
    model['position'].presence || 'NA'
  end

  def volume
    model['search_volume'].presence || 'NA'
  end

  def cpc
    model['cpc'].presence || 'NA'
  end

  def traffic
    model['traffic'].presence || 'NA'
  end

  private

  attr_accessor :model
end
