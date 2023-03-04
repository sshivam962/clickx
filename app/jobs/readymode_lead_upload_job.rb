# frozen_string_literal: true

class ReadymodeLeadUploadJob
  include Sidekiq::Worker

  def perform(id, agency_id)
    begin
      @request = Outscrapper::Request.find_by(id: id)
      current_agency = Agency.find(agency_id)
      ActiveRecord::Base.connection_pool.with_connection do
        ReadymodeLeadUploadService.process(
          request: @request,
          url: current_agency&.readymode_url
        )
      end
    rescue Exception => e
      @request.update(readymode_upload_status: :failed)
      Rails.logger.info "Failed to Upload contacts #{e.message}"
    end
  end

end
