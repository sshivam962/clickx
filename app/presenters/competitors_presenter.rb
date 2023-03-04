# frozen_string_literal: true
class CompetitorsPresenter
  def initialize(model)
    @model = model
  end

  def name
    model.name.presence || 'NA'
  end

  def logo
    model.logo.presence || URL
  end

  private

  URL = 'users/competitor.png'

  attr_accessor :model
end
