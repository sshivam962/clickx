# frozen_string_literal: true

class OneIMS::Base < ActiveResource::Base
  self.site = ENV['ONEIMS_HOME_REST_URL']
end
