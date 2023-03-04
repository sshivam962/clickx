# frozen_string_literal: true

require 'rails_helper'

class Validatable
  include ActiveModel::Validations
  validates_with AllowIframeValidator, attributes: [:url]
  attr_accessor :url
end

describe AllowIframeValidator do
  subject { Validatable.new }

  context 'without url' do
    it 'is valid' do
      expect(subject).to be_valid
    end
  end

  context 'url with xframe options' do
    it 'is invalid' do
      subject.url = 'https://www.eventbrite.com/d/il--chicago/music--events/'
      expect(subject).to be_invalid
    end
  end

  context 'url with content security policy' do
    it 'is invalid' do
      subject.url = 'https://www.cnn.com/'
      expect(subject).to be_invalid
    end
  end

  context 'url without iframe prevention' do
    it 'is valid' do
      subject.url = 'http://snip.ly/upgrade/'
      expect(subject).to be_valid
    end
  end
end
