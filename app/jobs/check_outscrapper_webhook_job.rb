class CheckOutscrapperWebhookJob
  include Sidekiq::Worker
  sidekiq_options queue: 'outscrapper_refresh_queue'

  def perform(request_id, lead_source_id)
    @outscrapper_request = Outscrapper::Request.where(
      external_requests_id: request_id
    ).first
    if @outscrapper_request.present? && @outscrapper_request.outscrapper_status != 'Success'
      RefreshOutscrapperDataJob.new.perform({ 'request_id' => @outscrapper_request.external_requests_id,
                                              'lead_source_id' => @outscrapper_request.lead_source_id}) 
    end  
  end    

end 