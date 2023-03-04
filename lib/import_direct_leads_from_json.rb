# frozen_string_literal: true
require 'json'

class ImportDirectLeadsFromJson
  def initialize(lead_source_id, lead_source_file)
    @lead_source = LeadSource.find(lead_source_id)
    @file_path = lead_source_file
  end

  def self.import(*args)
    new(*args).perform
  end

  def perform
    status = true
    begin
      file = open(@file_path).read
      data_hash = JSON.parse(file)
      cleaned_json = OutscrapperService.cleaned_response(data_hash)
      remain_email_count = @lead_source.remaining_count + cleaned_json.count
      @lead_source.update(remaining_count: cleaned_json.count)
      ImportDirectLeadsFromJsonJob.perform_async(@lead_source.id, @file_path, "JSON")
    rescue StandardError => e
      status = false
    ensure
      @lead_source.update(remaining_count: 0)
    end 
    status 
  end
end
