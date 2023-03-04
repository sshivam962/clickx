# frozen_string_literal: true

class ImportDirectLeadsFromJsonJob
  include Sidekiq::Worker

  def perform(lead_source_id, file, type)
    @lead_source = LeadSource.find(lead_source_id)
    @file_path = file
    ActiveRecord::Base.connection_pool.with_connection do
      case type
      
      when "Excel"
        sheet = Roo::Spreadsheet.open(@file_path)
        sheet.parse(headers: false)
        @data_hash = sheet.parse(headers: true)
      when "JSON"
        opened_file = open(@file_path).read
        @data_hash = JSON.parse(opened_file)
      end
      cleaned_json = OutscrapperService.cleaned_response(@data_hash)
      @data = Outscrapper::BulkData.create!(filename: @file_path, cleaned_data: cleaned_json, lead_source_id: @lead_source.id, status_success: false)
      CreateJsonLeadsInEmailProspecting.process(
        record_collections: @data.cleaned_data,
        lead_source: @lead_source
      )
    end
    @lead_source.update(remaining_count: 0)
    @data.update_attribute(:status_success, true)
  end
end  
