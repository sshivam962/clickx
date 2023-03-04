# frozen_string_literal: true

class Public::UsersController < PublicController
  def check_email
    user_exists = User.email_exists?(params[:email])

    if user_exists
      @magic_link = Magic::Link::MagicLink.new(email: params[:email])
      @magic_link.send_login_instructions
    end

    render json: { exists: user_exists }
  end
end
