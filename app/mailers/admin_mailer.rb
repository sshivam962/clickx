# frozen_string_literal: true

class AdminMailer < ApplicationMailer
  layout 'admin_mailer'

  def signup_links(links_expired_yesterday, links_expiring_today)
    @email = Email.find_by mailer_name: "signup_links"
    @links_expired_yesterday = links_expired_yesterday
    @links_expiring_today = links_expiring_today
    mail(
      from: 'Clickx<support@clickx.io>',
      to: @email.to_addresses,
      cc: @email.cc_addresses,
      bcc: @email.bcc_addresses,
      subject: 'Expired Signup Links'
    )
  end

  def trial_users_list
    @email = Email.find_by mailer_name: "trial_users_list"
    @businesses = Business.tagged_with('Trial').pluck(:name)
    mail(from: 'Clickx<support@clickx.io>',
         to: @email.to_addresses,
         cc: @email.cc_addresses,
         subject: "Trial Users List - #{Date.current.strftime('%B %d, %Y')}")
  end

  def empty_ranks_keyword(keywords, google_count)
    @google_count = google_count
    attachments['missing_keywords.csv'] = keywords
    mail(from: 'Clickx<support@clickx.io>',
         to: 'andy@oneims.com',
         subject: 'Failed Keyword Ranks')
  end

  def count_failed_keywords(google)
    @google = google
    mail(from: 'Clickx<support@clickx.io>',
         to: 'andy@oneims.com',
         subject: 'Number of keywords added to delayed queue')
  end

  def failed_keyword(message, error)
    @message = message
    @error   = error
    mail(from: 'Clickx<support@clickx.io>',
         to: 'andy@oneims.com',
         subject: 'Failed to execute the keyword ranking task')
  end

  def initial_keyword_submition(google_count, time)
    @google_count = google_count
    @time         = time
    mail(from: 'Clickx<support@clickx.io>',
         to: 'andy@oneims.com',
         subject: 'Keywords has been submitted to authority labs')
  end

  def non_service_clients_list
    @non_service_businesses = Agency.clickx.businesses.non_service.pluck(:name)

    mail(from: 'Clickx<support@clickx.io>',
         to: 'isaiah@oneims.info',
         cc: 'solomon@oneims.com',
         subject: "Non Service Clients Summmary - #{Date.current.strftime('%B %d, %Y')}")
  end

  def clients_list
    mail(from: 'Clickx<support@clickx.io>',
         to: 'solomon@oneims.com',
         cc: 'andy@oneims.com',
         subject: "Clients Summmary - #{Date.current.strftime('%B %d, %Y')}")
  end

  def semrush_credit_low(credits)
    @email = Email.find_by mailer_name: "semrush_credit_low"
    mail(from: 'Clickx<support@clickx.io>',
         to: @email.to_addresses,
         cc: @email.cc_addresses,
         subject: 'SEMRush API Credits running low',
         body: "Current SEMRush API Credit Remaining : #{credits}")
  end

  def authority_labs_low_balance(balance)
    @email = Email.find_by mailer_name: "authority_labs_low_balance"
    mail(from: 'Clickx<support@clickx.io>',
         to: @email.to_addresses,
         cc: @email.cc_addresses,
         subject: 'Clickx : Authority Labs Account Balance running low',
         body: "Current Authority Labs Balance : $#{balance}")
  end

  def inactive_free_clients_list(inactive_accounts)
    @email = Email.find_by mailer_name: "inactive_free_clients_list"
    @inactive_accounts = inactive_accounts

    mail(from: 'Clickx<support@clickx.io>',
         to: @email.to_addresses,
         cc: @email.cc_addresses,
         subject: "Inactive Free Clients - #{Date.current.strftime('%B %d, %Y')}")
  end

  def account_costs(billing_details, date)
    @email = Email.find_by mailer_name: "account_costs"
    @date = date
    @billing_details = billing_details

    billing_details.each do |key, value|
      agency = Agency.find_by(name: key)
      @invoice = invoice value, agency, @date
      @pdf = SimpleInvoicePdf.generate @invoice
      attachments["#{key}_#{@date.strftime('%B')}_#{@date.year}.pdf"] = @pdf
    end

    mail(from: 'Solomon <solomon@oneims.com>',
         to: @email.to_addresses,
         cc: @email.cc_addresses,
         subject: "Agency Cost Report #{@date.strftime('%B')} #{@date.year}")
  end

  def deleted_business_data_collection(business_name, keyword_csv, competition_csv)
    attachments["#{business_name}_keywords.csv"] = keyword_csv unless keyword_csv.empty?
    attachments["#{business_name}_competition.csv"] = competition_csv unless competition_csv.empty?
    body = if keyword_csv.empty? && competition_csv.empty?
      "The above business had no keywords or competitors to archive"
    else
      "Please find attached the keywords and competitions of the removed business"
    end
    mail(from: 'Solomon <solomon@oneims.com>',
         to: 'solomon@oneims.com, andy@oneims.com',
         subject: "Business: #{business_name} Archived/Deleted on #{Time.current.strftime('%B')} #{Time.current.year}",
         body: body)
  end

  def agency_agreement(agreement, user)
    @email = Email.find_by mailer_name: "agency_agreement"
    @agreement = agreement
    @user = user
    @agency = @agreement.agreementable
    attachments['agreement.pdf'] = open(@agreement.file.url).read
    mail(
      from: 'Clickx<support@clickx.io>',
      to: @email.to_addresses,
      cc: @email.cc_addresses,
      subject: 'Agency Agreement Signed'
    )
  end

  def business_agreement(agreement, user)
    @email = Email.find_by mailer_name: "business_agreement"
    @agreement = agreement
    @user = user
    @business = @agreement.agreementable
    attachments['agreement.pdf'] = open(@agreement.file.url).read
    mail(
      from: 'Clickx<support@clickx.io>',
      to: @email.to_addresses,
      cc: @email.cc_addresses,
      subject: 'Business Agreement Signed'
    )
  end


  def client_questionnaire questionnaire
    @email = Email.find_by mailer_name: "client_questionnaire"
    @questionnaire = questionnaire
    @client = @questionnaire.client
    @agency = @client.agency
    mail(
      from: 'Clickx<support@marketingportal.us>',
      to: @email.to_addresses,
      cc: @email.cc_addresses,
      bcc: 'andy@oneims.com',
      subject: "Client Questionnaire - #{@client.name}"
    )
  end


  def new_signup_request(signup_info)
    @email = Email.find_by mailer_name: "new_signup_request"
    @signup_info = signup_info
    mail(
      from: 'Clickx<support@clickx.io>',
      to: @email.to_addresses,
      cc: @email.cc_addresses,
      subject: 'New Signup Request'
    )
  end

  def new_referral_signup_request(signup_info, referrer, plan)
    @signup_info = signup_info
    @referrer = referrer
    @plan = plan
    mail(
      from: 'Clickx<support@clickx.io>',
      to: 'solomon@oneims.com, sales@clickx.io',
      bcc: 'andy@oneims.com',
      subject: 'New Referral Signup Request'
    )
  end

  def idle_agencies idle_agencies_info
    @email = Email.find_by mailer_name: "idle_agencies"
    @idle_agencies_info = idle_agencies_info
    mail(
      from: 'Clickx<support@clickx.io>',
      to: @email.to_addresses,
      cc: @email.cc_addresses,
      bcc: @email.bcc_addresses,
      subject: 'Idle Agencies without Stripe'
    )
  end

  def idle_agencies_with_stripe agencies, number_of_days
    @email = Email.find_by mailer_name: "idle_agencies_with_stripe"
    @agencies = agencies
    @number_of_days = number_of_days
    mail(
      from: 'Clickx<support@clickx.io>',
      to: @email.to_addresses,
      cc: @email.cc_addresses,
      bcc: @email.bcc_addresses,
      subject: "Idle Agencies with Stripe for #{@number_of_days} Days"
    )
  end

  def upcoming_subscriptions subscriptions
    @email = Email.find_by mailer_name: "upcoming_subscriptions"
    @upcoming_subscriptions = subscriptions
    mail(
      from: 'Clickx<support@clickx.io>',
      to: @email.to_addresses,
      cc: @email.cc_addresses,
      bcc: @email.bcc_addresses,
      subject: "Upcoming Stripe Subscriptions - #{Date.current.strftime('%B %d, %Y')}"
    )
  end

  def new_agency agency_id, created_by_id
    @email = Email.find_by mailer_name: "new_agency"
    @created_user = User.find(created_by_id)
    @agency = Agency.find(agency_id)
    mail(
      from: 'Clickx<support@clickx.io>',
      to: @email.to_addresses,
      cc: @email.cc_addresses,
      bcc: @email.bcc_addresses,
      subject: 'New Agency Created'
    )
  end

  def active_subscriptions subscriptions, cancelled
    @active_subs = subscriptions
    @cancelled_subs = cancelled
    mail(
      from: 'Clickx<support@clickx.io>',
      to: 'solomon@oneims.com',
      bcc: 'andy@oneims.com',
      subject: "Active Stripe Subscriptions - #{Date.current.strftime('%B %d, %Y')}"
    )
  end

  def challenge_offer_mail(agency_id)
    @agency = Agency.find(agency_id)
    mail(
      from: 'Clickx<support@clickx.io>',
      to: ['solomon@oneims.com', 'partners@clickx.io', 'sales@clickx.io', 'accounts@oneims.com'],
      bcc: 'andy@oneims.com',
      subject: "Challenge Offer Payment from #{@agency.name}",
      body: "Payment received for the Challenge Offer from the agency #{@agency.name}"
    )
  end

  def incoming_sms_notification(sms, sms_sender)
    @sms = sms
    @sms_sender = sms_sender
    mail(
      from: 'Clickx<support@clickx.io>',
      to: 'sales@clickx.io',
      cc: ['jschwalenberg@clickx.io', 'solomon@oneims.com'],
      subject: "New SMS Received From #{sms_sender_details(@sms_sender)}",
      body: "#{sms_sender_details(@sms_sender)} sent a message: #{@sms.body} at: #{@sms.created_at.strftime('%B %d, %Y %H:%M:%S')}"
    )
  end

  private

  def invoice(details, agency, date)
    @invoice = {
      currency: 'USD',
      unit_cost: 50,
      date: date,
      quantity: details[:count],
      agency: agency
    }
  end

  def sms_sender_details(sms_sender)
    if sms_sender.name.present?
      "#{sms_sender.name} (#{sms_sender.phone})"
    else
      sms_sender.phone
    end
  end
end
