require_relative 'boot'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Clickx
  class Application < Rails::Application
    config.load_defaults 5.1
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # config.autoload_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('lib')
    config.autoload_paths += %W(#{config.root}/config/routes)

    config.action_dispatch.perform_deep_munge = false

    config.action_view.field_error_proc = proc do |html_tag, instance|
      if instance.class == ActionView::Helpers::Tags::Label
        html_tag
      else
        if instance.error_message.is_a?(Array)
          %(<div class="error_field">#{html_tag}<span class="help-inline">&nbsp;#{instance.error_message.join(',')}</span></div>).html_safe
        else
          %(<div class="error_field">#{html_tag}<span class="help-inline">&nbsp;#{instance.error_message}</span></div>).html_safe
        end
      end
    end
    config.generators do |g|
      g.test_framework :rspec, views: false, fixture: true
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
      g.helper false
      g.stylesheets false
      g.javascripts false
      g.view_specs false
    end

    require 'json'
    require 'csv'

    # Use sidekiq as default queue adapter
    config.active_job.queue_adapter = :sidekiq
    Koala.config.api_version = "v14.0"
  end
end
