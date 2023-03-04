class ProceessScreenshotAndWordpressJob
  include Sidekiq::Worker

  def perform(direct_lead_ids)
    begin
      @direct_lead = DirectLead.find_by_id(direct_lead_ids)
      return if @direct_lead.blank?
      WebSiteScreenshotService.verify_image(@direct_lead)
      @direct_lead.update(wordpress: Website.wordpress?(@direct_lead.root_url))
    rescue => e
      Rails.logger.info "e.message"
    end  
  end 
end