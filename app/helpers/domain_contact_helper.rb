module DomainContactHelper
  def total_mail_send_today
    current_user.lead_contacts_emailed_today.count
  end
end  