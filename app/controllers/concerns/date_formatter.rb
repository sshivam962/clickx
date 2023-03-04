# frozen_string_literal: true

module DateFormatter
  extend ActiveSupport::Concern

  private

  def parse_us_format_string(date_string)
    return if date_string.blank?

    Date.strptime(date_string, '%m-%d-%Y')
  end
end
