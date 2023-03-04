json.report do
  if @report
    json.partial! 'ad_reports/shared/google_ad_report', report: @report
  else
    json.empty  true
  end
end
