# frozen_string_literal: true

json.businesses do
  json.array!(@businesses) do |business|
    json.id                     business.id
    json.name                   business.name
    json.current_month_reports  do
      json.partial! 'ad_reports/shared/fb_ad_report', report: {}
    end
    json.first_month_reports  do
      json.partial! 'ad_reports/shared/fb_ad_report', report: {}
    end
    json.second_month_reports  do
      json.partial! 'ad_reports/shared/fb_ad_report', report: {}
    end
  end
end
