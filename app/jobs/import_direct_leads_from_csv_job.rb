# frozen_string_literal: true

class ImportDirectLeadsFromCsvJob
  include Sidekiq::Worker

  def perform(lead_source_id, csv_file, bulk_data)
    @lead_source = LeadSource.find(lead_source_id)
    ActiveRecord::Base.connection_pool.with_connection do
      csv_text = open(csv_file).read
      csv = CSV.parse(csv_text, headers: true)
      if bulk_data
        @data = Outscrapper::BulkData.create!(filename: csv_file, cleaned_data: csv, lead_source_id: lead_source_id, status_success: false)
      end
      CreateLeadsInEmailProspecting.process(
        record_collections: csv,
        lead_source: @lead_source)
    end
    @lead_source.update(remaining_count: 0)
    if bulk_data
      @data.update_attribute(:status_success, true)
    end
  end

end  
