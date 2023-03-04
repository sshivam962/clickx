# frozen_string_literal: true

module ApplicationHelper
  def user_level_label(level)
    labels = { 1 => 'danger', 2 => 'warning', 3 => 'success' }
    text   = { 1 => 'Not Active', 2 => 'Occasional', 3 => 'Active' }
    content_tag(:span, text[level], class: "label label-#{labels[level]}")
  end

  def review_stars(rating)
    "https://s3.amazonaws.com/clickx-images/star_rating/#{rating}-star.png"
  end

  def current_day
    Date::DAYNAMES[Date.current.wday]
  end

  def current_user_dashboard
    if current_user.super_admin?
      '/s/clients/'
    elsif current_user.agency_admin?
      agency_clients_path
    elsif current_business
      "/b/dashboard"
    elsif current_user.business_user?
      '/clients/#/select'
    else
      '/'
    end
  end

  def current_tenent
    @current_tenent ||= request.env['Clickx-White-Labelled-Agency']
  end

  def white_labeled_client?
    current_tenent.present?
  end

  def in_same_tenent?
    request.host_with_port == current_agency.domain
  end

  def app_name
    return if request.host.eql?('app.marketingportal.us')
    return 'Clickx' unless white_labeled_client?
    current_tenent.white_label_name.presence || current_tenent.name.presence || 'Clickx'
  end

  def coupon_applied_info(coupon, total_price, is_trial)
    if coupon.amount_off.present?
      amount_off = coupon.amount_off / 100
      discount = [total_price, amount_off].min
      discount_text = "$#{format('%.02f', amount_off)} OFF"
    elsif coupon.percent_off.present?
      discount = total_price * (coupon.percent_off / 100.0)
      discount_text = "#{coupon.percent_off}\% OFF"
    end

    discount = format('%.02f', discount).to_s
    discount_msg = "Promo Code Applied : #{discount_text}"

    offer_msg =
      if is_trial
        "A $#{discount} discount will be applied at the end of your free trial"
      else
        "Coupon #{coupon.coupon_id} resulted in savings of $#{discount}"
      end

    if coupon.duration == 'repeating'
      discount_msg += " for #{coupon.duration_in_months} months"
      offer_msg += " for #{coupon.duration_in_months} months" unless is_trial
    end

    [discount_msg, offer_msg]
  end

  def discount_by_coupon(coupon, total_price, is_trial)
    if coupon.amount_off.present?
      amount_off = coupon.amount_off / 100
      [total_price, amount_off].min
    elsif coupon.percent_off.present?
      total_price * (coupon.percent_off / 100.0)
    end
  end

  def dummy_business?
    return false unless current_business
    current_business.dummy?
  end

  def cc_icon_klass brand
    case brand
    when 'American Express'
      'cc-amex'
    when 'Diners Club'
      'cc-diners-club'
    when 'Discover'
      'cc-discover'
    when 'JCB'
      'cc-jcb'
    when 'MasterCard'
      'cc-mastercard'
    when 'UnionPay'
      'cc'
    when 'Visa'
      'cc-visa'
    when 'Stripe'
      'cc-stripe'
    when 'PayPal'
      'cc-paypal'
    else
      'cc'
    end
  end

  def without_scheme(url)
    return '#' if url.blank?

    url.sub(/^https?\:\/\/(www.)?/,'')&.chomp('/')
  end

  def formatted_url(url)
    "//#{without_scheme(url)}"
  end

  def format_at_date(date)
    date.strftime('%Y-%m-%d at %H:%M %Z') unless date.nil?
  end

  def days_since date
    if date.present?
      "#{(Date.current - date.to_date).to_i} days ago"
    else
      'N/A'
    end
  end

  def days_from date
    return nil if date.blank?

    (Date.current - date.to_date).to_i
  end

  def lead_next_step_enabled?(step, agency)
    return true unless step.eql?('account_campaign_audit')
    return true if %w[pro advanced].include?(agency.growth_plan_key)
  end

  def coupon_applied_info_for_mail(coupon, plan_amount)
    if coupon.amount_off.present?
      amount_off = coupon.amount_off / 100
      discount = [plan_amount, amount_off].min
      discount_text = "$#{format('%.02f', amount_off)} OFF"
    elsif coupon.percent_off.present?
      discount = plan_amount * (coupon.percent_off / 100.0)
      discount_text = "#{coupon.percent_off}\% OFF"
    end

    discount = format('%.02f', discount).to_s
    promo_msg = "Promo Code Applied : #{discount_text}"

    discount_msg = "Coupon #{coupon.coupon_id} resulted in discount of $#{discount}"

    if coupon.duration == 'repeating'
      promo_msg += " for #{coupon.duration_in_months} months"
      discount_msg += " for #{coupon.duration_in_months} months"
    end

    { promo_msg: promo_msg, discount_msg: discount_msg }
  end

  def admin_course_progress_bar course
    progress = course.progress(current_user)
    progress_msg = if progress.zero?
      'Not Yet Started'
    elsif progress == 100
      'Completed'
    else
      "#{progress} % Completed"
    end

    if progress_msg.include?('Not Yet Started')
      <<~CODE
        <div class="progress-bar-wrapper">
          <div class="progress text-center">
            Not Yet Started
            <div class="progress-bar" style="width: 0%;"></div>
          </div>
        </div>
      CODE
    else
      <<~CODE
        <div class="progress-bar-wrapper">
          <div class="progress">
            <div class="progress-bar" style="width: #{progress}%;">
              <div class="progress__completed">#{progress_msg}</div>
            </div>
          </div>
        </div>
      CODE
    end.html_safe
  end

  def dummy_lead
    Lead.new(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.safe_email,
      company: Faker::Company.name,
      value: Faker::Number.number(4)
    )
  end

  def white_glove_service_enabled? package, plan
    false
  end

  def demo_login?
    return false if session[:agency_admin_id].blank?

    user = User.find(session[:agency_admin_id])
    current_business.eql?(Business.birch_homes) &&
      (user.ownable_id != Business.birch_homes.agency_id)
  end

  def in_currency(amount, currency)
    number_to_currency(
      CurrencyConverterService.convert(amount: amount, to: currency),
      precision: 0,
      unit: CURRENCIES[currency]
    )
  end

  def sort_order
    @order ||= params[:order].eql?('DESC') ? 'ASC' : 'DESC'
  end

  def get_percent(value, total)
    return 0 if total.zero?

    (value.to_f / total.to_f * 100).round(2)
  end

  def daterange_picker_format(start_date, end_date)
    "#{start_date.to_date.strftime('%m-%d-%Y')} - #{end_date.to_date.strftime('%m-%d-%Y')}"
  end
end
