# frozen_string_literal: true

class SyncWithCloseioJob
  include Sidekiq::Worker

  def perform(user_id)
    @user = User.find_by(id: user_id)
    return unless @user
    return unless @user.normal?
    return unless @user.agency_admin?
    return if lead_exists?(@user.email)

    resp = CloseApi.create_lead(closeio_lead_params)
    raise resp.to_s if resp['field-errors'].present? || resp['errors'].present?
  rescue StandardError => e
    ErrorNotify.sync_with_closeio(@user, e.message).deliver_now
  end

  private

  def lead_exists? email
    leads = CloseApi.fetch_leads_with_email(email)
    leads['total_results']&.positive?
  end

  def closeio_lead_params
    {
      name: @user.name,
      contacts: [{
        name: @user.name,
        emails: [
          {
            type: 'office',
            email: @user.email
          }
        ],
        phones: [
          {
            type: 'office',
            phone: @user.phone
          }
        ]
      }],
      custom: {
        "2 Account & Product Fit": 'Clickx - Agency Partner',
        "1 Lead Source": 'Agency Partner'
      }
    }
  end
end
