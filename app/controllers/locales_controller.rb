# frozen_string_literal: true

class LocalesController < ApplicationController
  LOCALE_CODES = JSON.parse(File.read('public/locale.json')).freeze

  def index
    render json: { data: LOCALE_CODES }
  end
end
