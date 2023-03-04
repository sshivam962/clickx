# frozen_string_literal: true
Before('@omniauth_test') do
  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
    provider: 'facebook',
    uid: '123545',
    credentials: {
      token: 'mock_token',
      secret: 'mock_secret'
    },
    info: {
      name: "test facebook user"
    }

    # etc.
  )
end
After('@omniauth_test') do
  OmniAuth.config.test_mode = false
end
