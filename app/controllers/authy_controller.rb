# frozen_string_literal: true

class AuthyController < Devise::DeviseAuthyController
  protected

    def after_authy_enabled_path_for(_resource)
      profile_path
    end

    def after_authy_verified_path_for(_resource)
      profile_path
    end

    def after_authy_disabled_path_for(_resource)
      profile_path
    end

    def invalid_resource_path
      profile_path
    end
end
