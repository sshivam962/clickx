Magic::Link.configure do |config|
  config.user_class = 'User' # Default is User
  config.email_from = 'Clickx<support@clickx.io>'
  config.token_expiration_hours = 1 # Default is 6
  config.force_new_tokens = true # Default is false
end
