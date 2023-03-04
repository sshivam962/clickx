# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Keyword Tag requests', type: :request do
  include_context 'authenticated business user'
  let(:keyword) { create(:keyword, :with_keyword_tags) }
  let(:keyword_tags) { keyword.keyword_tags }

  describe 'Tag keywords' do
    it 'adds tag to keywords' do
      tags = keyword_tags.select(:id, :name, :color, :business_id).map(&:as_json)
      post '/businesses/tags/tag_keywords', params: {
        id: keyword.business_id, business_keyword_ids: [keyword.id], tags: tags
      }
      expect(response.status).to eq(200)
    end
  end

  describe 'Untag keywords' do
    it 'removes tag from keywords' do
      post '/businesses/tags/untag_business_keyword', params: {
        id: business.id, business_keyword_ids: [keyword_tags[0].id]
      }
      expect(response.status).to eq(200)
    end
  end

  describe 'Delete tag' do
    it 'deletes tag and untags the corresponding keywords' do
      delete '/businesses/tags/destroy', params: {
        id: business.id, tag_id: keyword_tags[0].id
      }
      expect(response.status).to eq(200)
    end
  end
end
