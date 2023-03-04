# frozen_string_literal: true

module Api
  module V1
    class HelloBarSerializer < ActiveModel::Serializer
      attributes :id, :active, :template
    end
  end
end
