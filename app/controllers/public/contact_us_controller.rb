# frozen_string_literal: true

class Public::ContactUsController < PublicController

  def create
    AdminMailer.new_signup_request(signup_params.as_json).deliver_later
  end

  private

  def signup_params
    params.require(:signup).permit(
      :first_name, :last_name, :email, :phone, :company, :domain, :message
    )
  end
end
