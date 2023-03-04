class SuperAdmin::MailgunSubdomainsController < ApplicationController
  layout 'base'
  before_action :set_subdomain, only: :destroy

  def index
    @mailgun_subdomains = MailgunSubdomain.all
  end

  def create
    @mailgun_subdomain = MailgunSubdomain.create(mailgun_subdomain_params)

    if @mailgun_subdomain.persisted?
      flash[:success] = 'Mailgun subdomain created'
    else
      flash[:error] = @mailgun_subdomain.errors.full_messages.to_sentence
    end

    redirect_to super_admin_mailgun_subdomains_path
  end

  def destroy
    @mailgun_subdomain.destroy
    redirect_to super_admin_mailgun_subdomains_path
  end

  private

  def set_subdomain
    @mailgun_subdomain = MailgunSubdomain.find(params[:id])
  end

  def mailgun_subdomain_params
    params.require(:mailgun_subdomain).permit(
      :subdomain, :user_name, :password
    )
  end
end
