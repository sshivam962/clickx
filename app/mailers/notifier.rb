# frozen_string_literal: true

class Notifier < ApplicationMailer
  add_template_helper(ApplicationHelper)

  def new_comment_from_customer(content, comment, admin_email)
    @email_template = MailTemplate.where(mail_type: MailTemplate::Types[1]).first
    @user = comment.user
    get_data_objects(content)

    @content_path = "#{ROOT_URL}/#/#{@content.business_id}/contents/#{@content.id}"

    mail(from: 'Clickx<support@clickx.io>', to: admin_email, subject: @email_template.subject)
  end

  def content_feedback_from_customer(content, admin_user_email)
    get_data_objects(content)

    @email_template = MailTemplate.where(mail_type: MailTemplate::Types[2]).first
    @content_path = "#{ROOT_URL}/#/#{@content.business_id}/contents/#{@content.id}"

    mail(from: 'Clickx<support@clickx.io>', to: admin_user_email, subject: @email_template.subject)
  end

  def content_submitted_to_customer(content, user_email_ids, biz_id)
    get_data_objects(content)

    @email_template = MailTemplate.where(mail_type: MailTemplate::Types[3]).first
    @content_path = "#{ROOT_URL}/#/#{@content.business_id}/contents/#{@content.id}"
    @business = Business.find(biz_id)
    @agency = @business.agency

    mail(from: @agency.from_email, to: user_email_ids, subject: @email_template.subject, reply_to: @agency.reply_to_email)
  end

  def lead_create_mail(lead_id, agency_id, user_id)
    @lead = ::Lead.find lead_id
    @agency = Agency.find agency_id
    @user = User.find user_id
    mail(from: 'Clickx<support@clickx.io>',
         to: 'partners@clickx.io',
         reply_to: @lead.agency.admins.normal.map(&:email).join(','),
         subject: "New Lead: #{@lead.first_name} created by agency #{@agency.name}")
  end

  def adword_query_email(biz_id, path)
    @email = Email.find_by mailer_name: "adword_query_email"
    @business = Business.find(biz_id)
    @agency = @business.agency
    filename = "Search_Terms #{@business.name} #{Date.current.strftime('%Y%d%m')}.csv"
    attachments[filename] = { mime_type: 'text/csv', content: File.read(path) }

    to_mails = @email.to_addresses
    mail(
      from: @agency.from_email,
      to: to_mails,
      subject: "Weekly Search Terms: #{@business.name}",
      reply_to: @agency.reply_to_email
    )
  end

  def new_reviews_email(review_ids, email_ids, business_id)
    @reviews = Review.find(review_ids).group_by(&:location_name)
    @business = Business.find(business_id)
    @agency = @business.agency

    mail(from: @agency.from_email, to: email_ids,
         subject: 'New Review Email', reply_to: @agency.reply_to_email)
  end

  def location_info_updated(location, admin_email_ids, user)
    @location = location
    @business = @location.business
    @agency = @business.agency
    @user = user

    @attributes = %w[name address city state country zip phone mobile_phone toll_free website enquiry_email fax
                     categories operational_hours payment_methods products_services brands languages professional_associations
                     short_description medium_description full_description long_description number_of_users year_established]

    mail(from: @agency.from_email,
         to: admin_email_ids,
         subject: "Location updated by #{@business.name}",
         reply_to: @agency.reply_to_email)
  end

  # Not used anywhere. Need to confirm and remove if not used.
  def business_info_updated(business, admin_email_ids, user, changes)
    @business = business
    @agency = @business.agency
    @user = user
    @changes = changes

    mail(from: @agency.from_email,
         to: admin_email_ids,
         subject: "Business - #{@business.name} updated by #{@user.name}",
         reply_to: @agency.reply_to_email)
  end

  def questionnaire_answered(questionnaire, current_user)
    @questionnaire = questionnaire
    @business = @questionnaire.business
    @agency = @questionnaire.business.agency
    @current_user = current_user
    @user = @current_user

    mail(from: @agency.from_email,
         to: User.admins_mailing_list.pluck(:email),
         subject: "Questionnaire updated by #{@questionnaire.business.name}",
         reply_to: @agency.reply_to_email)
  end

  def new_content_order(content_order, user)
    @user = user
    @content_order = content_order
    @business = @content_order.business
    @agency = @content_order.business.agency
    to = User.admins_mailing_list.pluck(:email)
    to << 'Clickx<support@clickx.io>'
    mail(from: @agency.from_email,
         to: to,
         subject: "New content order placed by #{@content_order.business.name}",
         reply_to: @agency.reply_to_email)
  end

  def content_order_approval(content_order)
    @content_order = content_order
    @user = @content_order.user
    @user_name = @user.name.titleize
    @business = @content_order.business
    @agency = @business.agency
    mail(from: @agency.from_email,
         to: @user.email,
         subject: 'Approve content ordered for your campaign',
         reply_to: @agency.reply_to_email)
  end

  def self.send_weekly_mailer(biz, google_data, chart_url, top_10_keywords, top_10_google_ads_keywords, system_keyword, fb_campaigns, email_ids)
    email_ids.each do |email_id|
      weekly_mailer(biz, google_data, chart_url, top_10_keywords,
                    top_10_google_ads_keywords, system_keyword,
                    fb_campaigns, email_id).deliver_now
    end
  end

  def weekly_mailer(biz, google_data, chart_url, top_10_keywords, top_10_google_ads_keywords, system_keyword, fb_campaigns, email_ids)
    @business = biz
    @agency = biz.agency
    @top_10_keywords = top_10_keywords
    @google_data = google_data
    @chart_url = chart_url
    @top_10_google_ads_keywords = top_10_google_ads_keywords
    @system_keyword = system_keyword
    @email_logo = biz.agency_email_logo
    @fb_campaigns = fb_campaigns

    mail(
      from: biz.from_email,
      to: email_ids,
      subject: "Your weekly stats for #{@business.name} 📈",
      reply_to: @agency.reply_to_email
    ) do |format|
      format.html { render layout: 'weekly_mailer' }
    end
  end

  def weekly_mailer_summary(biz_statuses)
    @biz_statuses = biz_statuses
    date = Time.now
    @formatted_date = date.strftime("%B #{date.day.ordinalize}, %Y")
    mail(from: 'Solomon <solomon@clickx.io>',
         to: 'solomon@oneims.com, maria@oneims.com, andy@oneims.com, seoteam@oneims.com',
         subject: "Weekly Mailer Summary for #{@formatted_date}")
  end

  def marchex_monthly_summary(biz_statuses, start_time, end_time)
    @biz_statuses = biz_statuses
    @start_time = start_time.strftime("%B #{start_time.day.ordinalize}, %Y")
    @end_time = end_time.strftime("%B #{end_time.day.ordinalize}, %Y")

    mail(from: 'Solomon <solomon@clickx.io>',
         to: 'solomon@oneims.com, accounts@oneims.com',
         subject: "Monthly Call Analytics Summary for #{@start_time} - #{@end_time}")
  end

  def reminder_email_fill_campaign_data(business, update_location, update_intelligence)
    @update_location = update_location
    @update_intelligence = update_intelligence
    @business = business
    @agency = @business.agency
    mail(from: @agency.from_email,
         to: @business.users.business_users_mailing_list.pluck(:email),
         subject: 'Update campaign details',
         reply_to: @agency.reply_to_email)
  end

  def budget_pacing_summary_email(budget_pacing_biz_details, days_left, type)
    @email = Email.find_by mailer_name: "budget_pacing_summary_email"
    @budget_pacing_biz_details = budget_pacing_biz_details
    @days_left = days_left
    @type = type
    return false if @budget_pacing_biz_details.empty?

    to_mails = @email.to_addresses
    if ['PPC', 'Facebook Ads'].include?(@type)
      to_mails.push('elee@oneims.com', 'maria@oneims.com')
    end
    mail(
      from: 'Clickx<support@clickx.io>',
      to: to_mails,
      subject: "#{@type} Budget Pacing - #{Date.current.strftime('%Y-%m-%d')}"
    )
  end

  def budget_exceeded_clients_summary(budget_exceeded_clients, days_left, type)
    @email = Email.find_by mailer_name: "budget_exceeded_clients_summary"
    @budget_exceeded_clients = budget_exceeded_clients
    @days_left = days_left
    @type = type
    return false if @budget_exceeded_clients.empty?

    to_mails = @email.to_addresses
    mail(
      from: 'Clickx<support@clickx.io>',
      to: to_mails,
      subject:
        "#{@type} Budget Limit Exceeded - #{Date.current.strftime('%Y-%m-%d')}"
    )
  end

  def agency_report(agency)
    @businesses = agency.businesses
    @admins = agency.admins_with_email_preference('business_reports', 'business_performance_report')
    return false if @admins.empty?
    mail(from: 'Clickx<support@clickx.io>',
         to: @admins.pluck(:email),
         subject: "#{agency.name} report - #{Date.current.strftime('%Y-%m-%d')}")
  end

  def marketing_performance_goal(business, user)
    mail(from: 'Solomon <solomon@oneims.com>',
         to: 'andy@oneims.com',
         cc: 'solomon@oneims.com',
         subject: 'Marketing Performance Goal',
         body: "Marketing Performance Goal line has been turned off for #{business} by #{user}")
  end

  def business_support_mail(user, from_email, agency, content)
    @content = content
    @user = user
    @agency = agency
    reply_to = "#{user.name}<#{user.email}>"
    mail(from: from_email,
         to: @agency.support_email,
         subject: "You have a new support request from #{@user.name}",
         reply_to: reply_to)
  end

  private

  def get_data_objects(content)
    @content = content
    @business = content.business
    @agency = @business.agency
  end
end
