# frozen_string_literal: true

class AllowIframeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    valid = begin
      headers = HTTParty.get(value, headers: { 'User-Agent' => 'Clickx' }).headers
      headers['x-frame-options'].blank? && headers['content-security-policy'].blank?
    rescue SocketError
      false
    rescue ArgumentError
      true
    rescue OpenSSL::SSL::SSLError
      false
    end
    record.errors[attribute] << (options[:message] || 'can’t show Social Magnets on this page') unless valid
  end
end
