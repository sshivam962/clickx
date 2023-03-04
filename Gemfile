# frozen_string_literal: true
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '2.7.7'

gem 'rails', '~> 5.2.7'
gem 'rails-html-sanitizer'
gem 'pg'

gem 'sass-rails', '>= 5'
gem 'uglifier'
gem 'jquery-rails'
gem 'turbolinks'
gem 'haml-rails'
gem 'haml'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'momentjs-rails'
gem 'bootstrap3-datetimepicker-rails'
gem 'gravatar_image_tag'

gem 'angular-ui-bootstrap-rails', '~> 0.4'
gem 'angular-rails-templates'
gem 'angular_rails_csrf'
gem 'redactor-rails', github: 'redtachyons/redactor-rails'

gem 'devise'
gem 'devise_invitable'
gem 'devise-authy'
gem 'devise_masquerade'
gem 'devise_lastseenable'
gem 'magic-link', github: 'alfie-max/magic-link'
gem 'omniauth-oauth2', '~> 1.5.0'
gem 'omniauth-facebook', '~> 4.0.0'
gem 'omniauth-google-oauth2'
gem 'cloudinary'
gem 'aasm'
gem 'hashie'
gem 'dotenv-rails', require: 'dotenv/rails-now'
gem 'paper_trail'
gem 'diffy'
gem 'jbuilder'
gem 'carrierwave'#, '>= 1.0.0.rc'#, '< 2.0'
gem 'carrierwave-base64'
gem 'faraday'
gem 'jwt'
gem 'metainspector'
gem 'ids_please'
gem "roo"

gem 'google-api-client'
gem 'google-adwords-api'
gem 'google-ads-googleads', '~> 16.0.0'
gem 'geocoder'
gem 'httparty'
gem 'gibbon'

gem 'acts-as-taggable-on'#, '~> 5.0'
gem 'paranoia'
gem 'friendly_id'
gem 'public_suffix'
gem 'nested_form'
gem 'will_paginate'
gem 'wicked_pdf'
gem 'city-state'
gem 'caxlsx'
gem 'caxlsx_rails'
gem 'twilio-ruby'

gem 'sentry-raven'
gem 'puma'
gem 'sucker_punch'
gem 'connection_pool'
gem 'sidekiq'
gem 'sidekiq-throttler'
gem 'sidekiq-status'
gem 'rails-settings-cached'
gem 'stripe'
gem 'stripe_event'
gem 'obfuscate'

gem 'activerecord_json_validator'
gem 'koala'
gem 'microformats2'
gem 'rack-attack'
gem 'rack-timeout'
gem 'browser'
gem 'user_agent_parser'
gem 'referer-parser'
gem 'active_model_serializers'
gem 'countries'
gem 'api_cache'
gem 'dalli'
gem 'moneta'
gem 'wuparty', github: 'seven1m/wuparty'
gem 'groupdate'
gem 'clearbit'
gem 'bitly'
# gem 'postgres_ext'
gem 'active_record_union'
gem 'simple_form'
gem 'sequenced'
gem 'active_type'
gem 'merit'
gem 'ga_cookie_parser'
gem 'smarter_csv'
gem 'file_validators'
gem 'webpush'
gem 'serviceworker-rails'
gem 'bootsnap'
gem 'freemail'
gem 'sidekiq-failures'
gem 'link_thumbnailer'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'oj'
# Heroku platform api
gem 'platform-api'
gem "pundit"
gem 'attr_encrypted'
gem 'closeio'
gem 'callrail', github: 'alfie-max/callrail'
gem 'amoeba'
gem 'jquery-ui-rails', '~> 5.0', '>= 5.0.5'
gem 'acts_as_list'
gem 'rolify'
gem 'to_words'

gem 'money'
gem 'fixer_currency'

gem 'prawn'
gem 'prawn-table'

gem 'liquid'

gem 'hubspot-ruby', git: 'https://github.com/adimichele/hubspot-ruby'

gem 'faker'
gem 'ffaker'

gem 'pusher'

group :development do
  gem 'letter_opener'
  gem 'bullet'
  gem 'web-console'
  gem 'listen'
  gem 'spring-watcher-listen'
  gem 'binding_of_caller'
  # For memory profiling (requires Ruby MRI 2.1+)
  gem 'memory_profiler'
  gem 'cookie_decryptor'
  # For call-stack profiling flamegraphs (requires Ruby MRI 2.0.0+)
  # gem 'flamegraph'
  # gem 'stackprof'     # For Ruby MRI 2.1+
  # gem 'rack-mini-profiler'
  # gem 'fast_stack'    # For Ruby MRI 2.0
  # gem 'puma_worker_killer'
  # gem 'derailed'
  # gem 'pp_sql'
  gem 'guard-rspec', require: false
  gem "spring"
  gem 'spring-commands-rspec'
  gem "rubycritic", require: false
  gem 'wkhtmltopdf-binary'
  gem 'wkhtmltopdf-binary-edge'

  def os_is(re)
    !!(RbConfig::CONFIG['host_os'] =~ re)
  end

  gem 'libnotify', platforms: :ruby, install_if: os_is(/linux/)
  gem 'growl', platforms: :ruby, install_if: os_is(/darwin/)
  gem 'brakeman', require: false
end

group :development, :test do
  gem 'better_errors', '~> 2.0.0'
  gem 'factory_bot_rails'
  gem 'rspec-rails'#, '~> 3.6'
  gem 'rails-controller-testing'
  gem 'pry-rails'
  gem 'meta_request'
  gem 'shoulda-matchers'
  gem "json_matchers"
  gem 'bundler-audit', require: false
  gem 'overcommit', require: true
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'simplecov', require: false
  gem 'webmock'
  gem 'database_cleaner'
  gem 'fantaskspec'
  gem 'email_spec'
  gem 'vcr'
  gem 'cucumber-rails', require: false
  # gem 'capybara'
  # gem 'capybara-webkit', '~> 1.15.1'
  gem "chromedriver-helper"
  gem 'selenium-webdriver'
  gem 'timecop'
  gem 'rspec-sidekiq'
  gem 'rspec_junit_formatter'
  gem 'ruport'
end

group :production, :staging do
  gem 'font_assets'
  gem 'newrelic_rpm'
  gem 'heroku-deflater'
  gem 'wkhtmltopdf-heroku'
end

gem 'net-dns', '~> 0.9.0'
gem 'ckeditor'
gem 'cocoon'

gem 'activeresource'
gem "sidekiq-cron"

gem 'gon', '~> 6.4'
gem 'spreadsheet', '~> 1.3'
gem 'Indirizzo', '~> 0.1.7'

gem "ruby-openai"
gem "lockbox"
