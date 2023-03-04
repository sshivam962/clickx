# frozen_string_literal: true

class SuperAdmin::MailsController < ApplicationController
  layout 'base'
  before_action :set_email, only: %i[edit update]
  before_action :check_params_nil, only: %i[update]

  def index
    @emails = Email.order("created_at DESC")
  end

  def edit; end

  def update
    if @email.update(email_params)
      @redirect_url = super_admin_mails_path
    else
      @error = @email.errors.full_messages.to_sentence
    end
  end

  private

  def check_params_nil
    if params[:email][:to_addresses].nil?
      @email.update(to_addresses: "")
    end
    if params[:email][:cc_addresses].nil?
      @email.update(cc_addresses: "")
    end
    if params[:email][:bcc_addresses].nil?
      @email.update(bcc_addresses: "")
    end
  end

  def email_params
    params.require(:email).permit(to_addresses: [], cc_addresses: [], bcc_addresses: [])
  end

  def set_email
    @email = Email.find(params[:id])
  end

end
