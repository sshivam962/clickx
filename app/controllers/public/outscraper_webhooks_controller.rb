# frozen_string_literal: true
class Public::OutscraperWebhooksController < PublicController
  def callback
    if params['status'] == "SUCCESS"
      @outscrapper_request = Outscrapper::Request.where(
        external_requests_id: params['id']
      ).first
      if @outscrapper_request.present? && @outscrapper_request.outscrapper_status != 'Success'
        RefreshOutscrapperDataJob.new.perform({ 'request_id' => @outscrapper_request.external_requests_id,
                                                'lead_source_id' => @outscrapper_request.lead_source_id}) 
      end  
    end  
  end
end