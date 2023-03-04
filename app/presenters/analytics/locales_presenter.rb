# frozen_string_literal: true
module Analytics
  class LocalesPresenter < ApplicationPresenter
    def initialize(model)
      @model = model
    end

    def table_data
      @locale_data = model['table_data'].map { |data| Analytics::LocalePresenter.new(data) }
    end

    private

    attr_accessor :model
  end
end
