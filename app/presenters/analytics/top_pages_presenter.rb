# frozen_string_literal: true
module Analytics
  class TopPagesPresenter < ApplicationPresenter
    def initialize(model)
      @model = model
    end

    def table_data
      @top_page_data = model['table_data'].map { |data| Analytics::TopPresenter.new(data) }
    end

    private

    attr_accessor :model
  end
end
