# frozen_string_literal: true

class FullContact
  attr_accessor :email, :phone, :api_key
  include HTTParty
  base_uri 'https://api.fullcontact.com/v2/'

  def initialize(email:, phone: nil)
    @email = email
    @phone = phone
    @api_key = ENV['FULLCONTACT_API_KEY'] || 'b3414eac29394143' # TODO: Temporary
  end

  def person
    query = { apiKey: api_key }
    if email.present?
      query[:email] = email
    elsif phone.present?
      query[:phone] = phone
    else
      return
    end
    self.class.get('/person.json', query: query).body
  end
end
