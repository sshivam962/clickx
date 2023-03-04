# frozen_string_literal: true

# NOTE: middlewares are not autoloaded, restart the server after making change here

class ClickxWhiteLabel
  def initialize(app)
    @app = app
  end

  def call(env)
    domain = env['HTTP_HOST']
    if ROOT_URL.ends_with?(domain)
      Thread.current['Clickx-Domain'] = nil
      Thread.current['Clickx-FullDomain'] = nil
    else
      white_labelled_agency = ::Agency.white_labelled
                                      .where.not(domain: nil)
                                      .find_by(domain: domain)
      if white_labelled_agency
        env['Clickx-Domain'] = domain
        Thread.current['Clickx-Domain'] = domain
        Thread.current['Clickx-FullDomain'] = "#{url_scheme(env)}://#{domain}"
        env['Clickx-White-Labelled-Agency'] = white_labelled_agency
        Rails.logger.info 'white labelled'
      end
    end
    if oauth_callback_end_point?(env) && ROOT_URL.ends_with?(domain) && oauth_callback_state_data(env)
      redirect oauth_callback_state_data(env) + env['REQUEST_URI']
    else
      @app.call(env)
    end
  end

  private

  def redirect(location)
    [302, { 'Location' => location, 'Content-Type' => 'text/html' }, ['Moved Temporarily']]
  end

  def oauth_callback_end_point?(env)
    env['REQUEST_PATH'].match?(/(auth\/.+\/callback)|(oauth2callback)/)
  end

  def oauth_callback_state_data(env)
    state = Rack::Utils.default_query_parser.parse_nested_query(env['QUERY_STRING'])['state']
    return nil if state.blank?
    Rails.cache.fetch(state).fetch(:domain)
  end

  def url_scheme(env)
    if env[Rack::HTTPS] == 'on'
      'https'
    elsif env[Rack::Request::HTTP_X_FORWARDED_SSL] == 'on'
      'https'
    elsif env[Rack::Request::HTTP_X_FORWARDED_SCHEME]
      env[Rack::Request::HTTP_X_FORWARDED_SCHEME]
    elsif env[Rack::Request::HTTP_X_FORWARDED_PROTO]
      env[Rack::Request::HTTP_X_FORWARDED_PROTO].split(',')[0]
    else
      env[Rack::RACK_URL_SCHEME]
    end
  end
end
