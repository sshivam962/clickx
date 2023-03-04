module UptimeRobot
  URL = 'https://api.uptimerobot.com/v2/'

  module_function

  def create_monitor(name, domain_url)
    resp = Faraday.post(URL + 'newMonitor') do |req|
      req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
      req.headers['Cache-Control'] = 'no-cache'
      req.body = "api_key=#{ENV['UPTIME_ROBOT_API_KEY']}"\
                  "&format=json"\
                  "&type=1"\
                  "&url=#{domain_url}"\
                  "&friendly_name=#{name}"\
    end
    JSON.parse(resp.body)
  end

  def delete_monitor(monitor_id)
    resp = Faraday.post(URL + 'deleteMonitor') do |req|
      req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
      req.headers['Cache-Control'] = 'no-cache'
      req.body = "api_key=#{ENV['UPTIME_ROBOT_API_KEY']}"\
                  "&id=#{monitor_id}"
    end
    JSON.parse(resp.body)
  end
end
