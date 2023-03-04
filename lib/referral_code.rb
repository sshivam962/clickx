# frozen_string_literal: true

class ReferralCode
  CHARACTERS = '0123456789ABCDEFGHJKLMNPQRTUVWXY'
  LENGTH     = CHARACTERS.length.freeze

  # Generates a random referral code of the format. Example:
  #
  #     ReferralCode.generate
  #     #=> "97C1UKLXQVTD"
  #
  # The characters 'O', 'I' and 'Z' are excluded from the generated code, to
  # avoid errors when users mis-read these characters as 0, 1 or 2. These
  # typos from the users can be avoided by converting those characters from
  # user input to 0, 1, or 2 before checking with the referral code.
  #
  def self.generate
    (1..12).map { CHARACTERS[rand(LENGTH)] }.join
  end

  def self.agency_referral_link(code)
    begin
      client = Bitly::API::Client.new(token: ENV['BITLY_API_KEY'])
      bitlink = client.create_bitlink(
        long_url: "#{ROOT_URL}/a/signup/starter/#{code}",
        title: 'Clickx Agency Signup'
      )
      bitlink.link
    rescue StandardError
      "#{ROOT_URL}/a/signup/starter/#{code}"
    end
  end
end
