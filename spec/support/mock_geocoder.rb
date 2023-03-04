# frozen_string_literal: true

require 'geocoder/results/base'

module MockGeocoder
  def self.included(base)
    base.before do
      allow(::Geocoder).to receive(:search).and_raise(
        RuntimeError.new('Use "mock_geocoding!" method in your tests.')
      )
    end
  end

  def mock_geocoding!(options = {})
    options.reverse_merge!(
      address: 'Address',
      coordinates: [1, 2],
      state: 'State',
      state_code: 'State Code',
      country: 'Country',
      country_code: 'Country code'
    )

    MockResult.new.tap do |result|
      options.each do |prop, val|
        allow(result).to receive(prop).and_return(val)
      end
      allow(Geocoder).to receive(:search).and_return([result])
    end
  end

  class MockResult < ::Geocoder::Result::Base
    def initialize(data = [])
      super(data)
    end
  end
end
