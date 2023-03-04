# frozen_string_literal: true

class Public::DomainContactsController < PublicController
  def unsubscribe
    contact = DomainContact.fetch_by_encrypted_email(params[:encrypted_email])
    if contact.nil? || contact.unsubscribed?
      @unsubscribed = true
    else
      contact.update(unsubscribed: true)
    end
    render layout: false
  end

end
