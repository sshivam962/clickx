module Sms
  def self.send_msg to_num, msg, from: ENV['TWILIO_SUPPORT_NUMBER']
    @client = Twilio::REST::Client.new
    @client.messages.create(
      from: from,
      to: to_num,
      body: msg
    )
  rescue
  end
end
