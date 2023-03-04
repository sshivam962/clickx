# frozen_string_literal: true

class Agency::SupportController < Agency::BaseController
  skip_before_action :agency_active_check, :active_agency?
  before_action :perform_authorization

  def index; end

  def create
    agency_name = current_agency.name
    user_name = current_user.name
    user_email = current_user.email
    subject = params[:support_mail][:subject]
    content = params[:support_mail][:content]

    SupportMailer.feedback_info(user_name, user_email, agency_name, subject, content).deliver_later

    redirect_to root_path
  end

  def perform_authorization
    authorize current_agency, :support?
  end

end
