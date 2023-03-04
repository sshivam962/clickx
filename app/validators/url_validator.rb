# frozen_string_literal: true

class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return true if value.blank?
    valid = begin
      uri = Addressable::URI.parse(value)
      uri.is_a?(Addressable::URI) && uri.tld.present?
    rescue PublicSuffix::DomainInvalid, PublicSuffix::DomainNotAllowed, Addressable::URI::InvalidURIError
      false
    end
    record.errors[attribute] << (options[:message] || 'is an invalid URL') unless valid
  end
end
