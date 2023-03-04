# frozen_string_literal: true

module BusinessHelper
  def set_card_type card_info
    case card_info
    when 'visa'
      'visacard'
    when 'american express'
      'amex'
    when 'mastercard'
      'mastercard'
    when 'jcb'
      'jcb'
    when 'diners club'
      'diners-club'
    when 'discover'
      'discover'
    end
  end

  def get_active_class path
    'active' if current_page?(path)
  end

  def pad2 number
    (number < 10 ? '0' : '') + "#{number}"
  end

  def set_duration duration
    return if duration.blank?

    hours = pad2((duration / 3600).to_i)
    minutes = pad2(((duration % 3600) / 60).to_i)
    seconds = pad2((duration % 60).to_i)
    "#{hours}:#{minutes}:#{seconds}"
  end
end
