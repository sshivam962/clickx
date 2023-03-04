# frozen_string_literal: true

class Network::SignupsController < ActionController::Base
  layout 'network_signup'

  before_action :ensure_no_user_logged_in

  def new
    @user = User.new(role: User::Contractor)
    @user.build_network_profile
  end

  def create
    @user = User.new(contractor_user_params)
    raise 'Email ID already exists' if user_exists?
    @user.save

    linkedin_url_format = 'https://www.linkedin.com/in/'
    linkedin_url = params[:user][:network_profile_attributes][:linkedin] rescue nil
    linkedin = linkedin_url.include?(linkedin_url_format) ? linkedin_url : "#{linkedin_url_format}#{linkedin_url}"
    @user.create_network_profile(linkedin: linkedin) if linkedin.present?

    NetworkMailer.new_user(@user.id).deliver_later
  rescue StandardError => e
    @msg = e.message
    @error = true
  end

  private

  def ensure_no_user_logged_in
    redirect_to root_path if current_user.present?
  end

  def contractor_user_params
    params.require(:user).permit(:first_name, :last_name, :phone, :email, :password, :role)
  end

  def user_exists?
    User.exists? email: contractor_user_params[:email]
  end
end
