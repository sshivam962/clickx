class SuperAdmin::MailTemplatesController < ApplicationController
  layout 'base'
  before_action :set_template, only: [:edit, :update]

  def index
    @templates = MailTemplate.all
  end

  def edit;end

  def update
    if @template.update(template_params)
      redirect_to super_admin_mail_templates_path
    end
  end

  private

  def set_template
    @template = MailTemplate.find(params[:id])
  end

  def template_params
    params.require(:mail_template).permit(:welcome_text, :agency_note, :subject)
  end
end
