# frozen_string_literal: true

module Api
  module V1
    class CompetitionSerializer < ActiveModel::Serializer
      attributes :id, :name, :business_id, :summary, :backlinks, :anchor_text, :top_pages, :created_at, :updated_at, :keywords_organic, :keywords_adwords
    end
  end
end
