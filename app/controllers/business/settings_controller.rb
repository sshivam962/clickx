class Business::SettingsController < Business::BaseController

  before_action :set_business, only: %i[
    update_logo update_business set_budget content_ordering
    set_content_order update_mailing_list
  ]
  before_action :ensure_logo, only: %i[update_logo]

  def general; end

  def budget_pacing; end

  def content_ordering
    @content_order = @business.content_order_default
  end

  def email_notifications; end

  def update_logo
    image_url =
      Cloudinary::Uploader.upload(
        params[:image], options = {folder: 'business_logos'}
      )['secure_url']
    @business.update(params[:logo] => image_url)
  end

  def update_business
    @business.update_attributes(business_update_params)
  end

  def remove_card
    @card = PaymentDetail.find params[:id]
    @card.destroy
  end

  def set_budget
    @business.update_attributes(budget_params)
  end

  def set_default_content_order
    @business.content_order_default.update_attributes(content_order_params)
  end

  def update_mailing_list
    @invalid_emails = find_invalid_emails(params[:contact_mailing_list])
    if @invalid_emails.present?
      @invalid_emails
    else
      @business.update(contact_mailing_list: params[:contact_mailing_list].split(","))
    end
  end

  private

  def set_business
    @business = current_business
  end

  def business_update_params
    params.require(:business).permit(
      :locale, :timezone, :target_city
    )
  end

  def budget_params
    params.require(:business).permit(:ppc_budget, :fb_budget)
  end

  def content_order_params
    params.require(:content_order_default).permit(:company_information, :target_audience, :things_to_mention, :things_to_avoid)
  end

  def ensure_logo
    logos = %w[logo square_logo email_logo grader_logo favicon]
    return if logos.include?(params[:logo])

    redirect_to business_settings_path
  end

  def find_invalid_emails emails
    invalid_emails = []
    emails.split(",").each do |email|
      invalid_emails.push(email) if URI::MailTo::EMAIL_REGEXP.match(email) == nil
    end
    invalid_emails
  end
end
