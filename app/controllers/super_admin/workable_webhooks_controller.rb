class SuperAdmin::WorkableWebhooksController < ApplicationController
  layout 'base'

  skip_before_action :verify_authenticity_token, only: :callback
  skip_before_action :authenticate_user!, only: :callback

  def index
    @webhooks = WorkableWebhook.all
  end

  def create
    response = Workable.create_webhook params[:webhook][:target_url]
    message = if response['error'].present?
                response['error']
              else
                @webhook = WorkableWebhook.create(
                  webhook_params.merge(id: response['id'])
                )
                'Webhook created successfully'
              end
    redirect_to super_admin_workable_webhooks_path, notice: message
  end

  def destroy
    @webhook = WorkableWebhook.find params[:id]
    Workable.delete_webhook @webhook.id
    @webhook.destroy
    redirect_to super_admin_workable_webhooks_path, notice: 'Webhook deleted successfully'
  end

  private

  def webhook_params
    params.require(:webhook).permit(:target_url)
  end
end
