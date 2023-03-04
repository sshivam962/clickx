# frozen_string_literal: true

module CookieManager
  extend ActiveSupport::Concern

  def set_cookie(key, value)
    session[key.to_sym] = cookies[key.to_sym] = value
  end

  def get_cookie(key)
    session[key.to_sym] || cookies[key.to_sym]
  end

  def clear_cookie(key)
    set_cookie(key, nil)
  end

  def clear_all_user_cookies
    clear_cookie(:admin_id)
    clear_cookie(:agency_admin_id)
    clear_cookie(:current_agency_id)
    clear_cookie(:current_business_id)
  end
end
