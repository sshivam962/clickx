module Website
  module_function

  def wordpress?(url)
    uri = URI.parse(url)
    url =
      %w( http https ).include?(uri.scheme) ? url : "https://#{url}"
    doc = Nokogiri::HTML(open(url))
    !(doc.to_s !~ /wordpress|wp-content|wp-includes/i)
  rescue
    false
  end

  def hubspot?(url)
    doc = Nokogiri::HTML(open(url))
    return true if doc.at("meta[name='generator']")['content'].eql?('HubSpot')
    return true if doc.to_s.include?('js.hs-scripts.com')
  rescue
    false
  end
end
