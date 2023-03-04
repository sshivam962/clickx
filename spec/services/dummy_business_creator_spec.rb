# frozen_string_literal: true

require 'rails_helper'
RSpec.describe DummyBusinessCreator do
  it 'works' do
    expect(subject.run).to be_truthy
  end
end
