class ReadymodeLeadUploadService
  def initialize(params)
    @url = params[:url]
    @request = params[:request]
    @outscrapper_data = @request.outscrapper_data
  end

  def self.process(*args)
    new(*args).perform
  end

  def perform
    begin
      @response = request_from_readymode
      @outscrapper_data.readymode_response = @response
      @outscrapper_data.save
      @request.update(readymode_upload_status: :completed)
    rescue Exception => e
      @request.update(readymode_upload_status: :failed)
      Rails.logger.info "Failed to Upload contacts #{e.message}"
    end
  end

  def lead_data_params
    leads = {}
    @outscrapper_data.response_json.each_with_index do |data, index|
      next if data["phone"].nil?
      leads["lead[#{index}]"] = 
        {
          firstName: data["name"],
          phone: data["phone"],
          phone2: data["phone_1"],
          address: data["full_address"],
          city: data["city"],
          state: data["state"]
        }
    end
    { body: leads }          
  end

  def request_from_readymode
    HTTParty.post(
      @url, lead_data_params)
  end

end    