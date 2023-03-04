# frozen_string_literal: true
module Analytics
  class SocialsPresenter < ApplicationPresenter
    def initialize(model)
      @model = model
    end

    def table_data
      @social_data = model['table_data'].map { |data| Analytics::SocialPresenter.new(data) }
    end

    private

    attr_accessor :model
  end
end
