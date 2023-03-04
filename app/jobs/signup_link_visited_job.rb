# frozen_string_literal: true

class SignupLinkVisitedJob
  include Sidekiq::Worker

  def perform(signup_link_id, ip, referer, original_url, user_agent)
    location = Geocoder.search(ip).first
    country = "#{location.country}" rescue nil
    state = "#{location.state}" rescue nil
    city = "#{location.city}" rescue nil
    postal_code = "#{location.postal_code}" rescue nil

    @browser = Browser.new(user_agent)
    os = @browser.platform.name
    browser = @browser.name

    def device_type
      @device_type ||= begin
        browser = @browser
        if browser.bot?
          'Bot'
        elsif browser.device.tv?
          'TV'
        elsif browser.device.console?
          'Console'
        elsif browser.device.tablet?
          'Tablet'
        elsif browser.device.mobile?
          'Mobile'
        else
          'Desktop'
        end
      end
    end

    SignupMailer.agency_signup_link({
      signup_link_id: signup_link_id,
      ip: ip,
      referer: referer,
      original_url: original_url,
      country: country,
      state: state,
      city: city,
      postal_code: postal_code,
      device_type: device_type,
      os: os,
      browser: browser
    }).deliver_later
  end
end
