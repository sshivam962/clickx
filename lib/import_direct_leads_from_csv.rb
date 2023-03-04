require 'csv'

class ImportDirectLeadsFromCsv
  def initialize(lead_source_id, lead_source_file, bulk_data)
    @lead_source = LeadSource.find(lead_source_id)
    @file_path = lead_source_file
    @bulk_data = bulk_data
  end

  def self.import(*args)
    new(*args).perform
  end

  def perform
    status = true
    begin
      csv_text = open(@file_path).read
      csv = CSV.parse(csv_text, headers: true)
      remain_email_count = @lead_source.remaining_count + csv.count
      @lead_source.update(remaining_count: csv.count)
      ImportDirectLeadsFromCsvJob.perform_async(@lead_source.id,  @file_path, @bulk_data)
    rescue StandardError => e
      @lead_source.update(remaining_count: 0)
      status = false
    ensure
      @lead_source.update(remaining_count: 0)
    end 
    status 
  end
end
