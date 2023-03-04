class CheckFailedOutscrapperWebhookJob
  include Sidekiq::Worker
  sidekiq_options queue: 'outscrapper_refresh_queue'

  def perform(request_id)
    @outscrapper_request = Outscrapper::Request.where(
      external_requests_id: request_id
    ).first
    if @outscrapper_request.present? && @outscrapper_request.outscrapper_status == "Pending"
      @outscrapper_request.update(outscrapper_status: "Failed")
    end  
  end    

end 