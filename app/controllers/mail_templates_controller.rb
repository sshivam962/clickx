# frozen_string_literal: true

class MailTemplatesController < ApplicationController
  before_action :get_current_user
  before_action -> { authorize :businesses, :manage? }

  def index
    render json: MailTemplate.all.to_json
  end
  #   # we don't create templates from UI,
  #   # as n when client ask we add new type of template in model & seed a template for him
  #   # so in admin panel he edits it as he wants hence commenting def create
  #   def create
  #     mail = MailTemplate.new(mail_params)
  #     mail.user = current_user
  #     if save
  #       render json: {status: 201,
  #                     location: mail}
  #     else
  #       render json: {status: 406,
  #                     location: mail,
  #                     errors: mail.errors}
  #     end
  #   end

  def show
    mail = MailTemplate.find(params[:id])
    render json: mail.to_json
  end

  def edit
    mail = MailTemplate.find(params[:id])
    render json: mail.to_json
  end

  def update
    mail = MailTemplate.find(params[:id])
    mail.user = current_user
    if mail.update_attributes(mail_params)
      render json: { status: 201,
                     location: mail }
    else
      render json: { status: 406,
                     location: mail,
                     errors: mail.errors }
    end
  end

  private

  def mail_params
    params.require(:mail).permit!
  end
end
