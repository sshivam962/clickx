# frozen_string_literal: true
class ContentsPresenter
  delegate :created_at, :updated_at, to: :model

  def initialize(model)
    @model = model
  end

  def show_title
    model.title.presence || 'NA'
  end

  def state
    model.state.presence || 'NA'
  end

  private

  attr_accessor :model
end
