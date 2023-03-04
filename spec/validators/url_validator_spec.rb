# frozen_string_literal: true

require 'rails_helper'

class URLValidatable
  include ActiveModel::Validations
  validates_with UrlValidator, attributes: [:url]
  attr_accessor :url
end

describe URLValidatable do
  subject { described_class.new }

  context 'without url' do
    it 'is valid' do
      expect(subject).to be_valid
    end
  end

  context 'random text' do
    it 'is invalid' do
      subject.url = 'jhsfhsfhg'
      expect(subject).to be_invalid
    end
  end

  context 'text with spaces' do
    it 'is invalid' do
      subject.url = 'Telephone station installer'
      expect(subject).to be_invalid
    end
  end

  context 'without protocol prefix' do
    it 'is invalid' do
      subject.url = 'www.cnn.com/'
      expect(subject).to be_invalid
    end
  end

  context 'without valid tld' do
    it 'is invalid' do
      subject.url = 'https://clickx'
      expect(subject).to be_invalid
    end
  end

  context 'full url' do
    it 'is valid' do
      subject.url = 'https://snip.ly/upgrade/'
      expect(subject).to be_valid
    end
  end
end
