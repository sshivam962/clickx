# frozen_string_literal: true

class ImportOutscrapperDataJob
  include Sidekiq::Worker

  sidekiq_options queue: 'outscrapper_import_queue'

  def perform(lead_source_id, cleaned_json)
    begin
      @lead_source = LeadSource.find(lead_source_id)
      ActiveRecord::Base.connection_pool.with_connection do
        CreateJsonLeadsInEmailProspecting.process(
          record_collections: cleaned_json,
          lead_source: @lead_source
        )
      end
    ensure
      @lead_source.update(remaining_count: 0)
      # ImportCompleteMailer.data_import_completed(@lead_source).deliver_now
    end
  end

end
