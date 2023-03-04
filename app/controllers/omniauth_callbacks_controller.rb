# frozen_string_literal: true

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :create_user, only: %i[facebook google_oauth2]

  def facebook; end

  def google_oauth2; end

  def failure
    redirect_to new_user_registration_url
  end

  private

  def create_user
    auth = request.env['omniauth.auth']
    @identity = Identity.find_with_omniauth(auth)
    @identity = Identity.create_with_omniauth(auth) if @identity.nil?
    if @identity.user.present?
      @user = @identity.user
      sign_in_and_redirect @user, event: :authentication
    else
      @user = User.from_omniauth(request.env['omniauth.auth'])
      if @user.persisted?
        @identity.user = @user
        @identity.save
        sign_in_and_redirect @user, event: :authentication
      elsif !white_labeled_client?
        render 'signups/free', layout: 'signup'
      else
        redirect_to 'http://' + request.env['omniauth.origin'] and return
      end
    end
  end
end
