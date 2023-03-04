# frozen_string_literal: true

module MailerHelper
  def utm_key_name(key)
    key.titleize.gsub('Utm', 'UTM')
  end
end
