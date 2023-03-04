# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Country locales', type: :request do
  include_context 'authenticated business user'

  describe 'GET /locales' do
    it 'returns the country locale object' do
      get locales_path
      expect(response).to have_http_status(200)
    end
  end
end
