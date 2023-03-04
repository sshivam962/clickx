class RefreshOutscrapperDataJob
  include Sidekiq::Worker

  sidekiq_options throttle: {
    threshold: 150,
    period: 1.hour,
    key: 'outscrapper_refresh_job',
  }, queue: 'outscrapper_refresh_queue'

  def perform(*args)
    request_id = args[0]['request_id']
    lead_source_id = args[0]['lead_source_id']
    response_data =
      OutscrapperService.specific_data_search(request_id) || {}
    if response_data['status'] == 'Success'
      @outscrapper_request = Outscrapper::Request.where(
        external_requests_id: request_id
      ).first

      @outscrapper_request.update_columns(outscrapper_status: 'Success')
      lead_source = LeadSource.find_by(id: lead_source_id)
      current_agency = lead_source.agency
      # RequestCompletedMailer.request_completed(@outscrapper_request, lead_source).deliver_now
      credit_balance = current_agency.outscraper_limit.credit_balance
      current_agency.outscraper_limit.update(credit_balance: credit_balance.to_i - @outscrapper_request.limit)
      OutscrapperService.add_to_outscrapper_data(
        @outscrapper_request, response_data, lead_source_id
      )
    end
  end
end
