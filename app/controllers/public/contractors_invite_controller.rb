# frozen_string_literal: true

class Public::ContractorsInviteController < PublicController
  def unsubscribe
    contractor = ContractorsInvite.fetch_by_encrypted_email(
      params[:encrypted_email]
    )

    if contractor.nil? || contractor.unsubscribed?
      @unsubscribed = true
    else
      contractor.update(unsubscribed: true)
    end
    render layout: false
  end
end
