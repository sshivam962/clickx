# frozen_string_literal: true

class WebSiteScreenshotService
  class << self
    def verify_image(direct_lead)
      return false if direct_lead.blank?
      root_url = direct_lead&.root_url
      return false if root_url.blank?
      conn = Faraday.new(
        url: 'https://api.site-shot.com',
        params: {'url': root_url,
              'width': 1280,
              'height': 1280,
              'format': 'png',
              'response_type': 'json'
              },
        headers: {'Content-Type' => 'application/x-www-form-urlencoded',
                  "Accept": "text/plain",
                  "userkey": ENV['SITESHOT_API_KEY']
                }
      )
      response = conn.post('')
      response_body = JSON.parse(response.body)
      return false if response_body.keys.include?("error")
      return false if response_body["image"].blank? || response_body["image"].split(',')[1].blank?
      set_picture(response_body["image"].split(',')[1], direct_lead)
      true
    end

    def set_picture(image, direct_lead)
      temp_file = Tempfile.new(["temp_#{direct_lead.id}", '.png'], :encoding => 'ascii-8bit')
      begin
        temp_file.write(Base64.decode64(image))
        direct_lead.screenshot_image = temp_file
        direct_lead.save
      ensure
        temp_file.close
        temp_file.unlink
      end
    end
  end
end  