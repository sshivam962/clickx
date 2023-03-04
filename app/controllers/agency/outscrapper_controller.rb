# frozen_string_literal: true
class Agency::OutscrapperController < Agency::BaseController
  require 'indirizzo'

  def index
    @outscrapper_requests = current_agency.outscrapper_requests.paginate(page: params[:page], per_page: 10)
  end

  def outscrapper_data
    categories_array = params[:outscrapper_data][:category].reject(&:empty?)
    states_array = params[:outscrapper_data][:state].reject(&:empty?)
    cities_array = params[:city].reject(&:empty?) unless params[:city].nil?
    limit = params[:outscrapper_data][:limit]
    lead_source_id = params[:outscrapper_data][:lead_source_id]
    zip_codes = ((params[:outscrapper_data][:zip]).split(/,\s*/)).take(25)
    query_combination = get_query_combination(categories_array, states_array, cities_array, zip_codes)

    credit_balance = current_agency.outscraper_limit.credit_balance
    @request_process = (credit_balance > limit.to_i )
    if @request_process
      resp = OutscrapperService.search_v2(query_combination, limit)
      gz = Zlib::GzipReader.new(StringIO.new(resp.body.to_s))
      uncompressed_string = gz.read
      # current_agency.credit_balance.update(credits: credit_balance.to_i - limit.to_i)
      Rails.logger.debug "======response======#{resp.inspect}============="
      @add_data = add_to_outscrapper_requests(JSON.parse(uncompressed_string), resp.env.url, lead_source_id, categories_array, states_array, cities_array, limit, zip_codes)
    end
    if @add_data
      render json: {code: 200, response: "Created"}
    else
      render json: {code: 422, response: "Error"}
    end
  end

  def outscrapper_advanced_data
    query =  params[:outscrapper_advanced_data][:data_query]
    lead_source_id = params[:outscrapper_advanced_data][:lead_source_id]
    limit = params[:outscrapper_advanced_data][:limit]
    credit_balance = current_agency.outscraper_limit.credit_balance
    @request_process = (credit_balance > limit.to_i)
    if @request_process
      resp = OutscrapperService.advanced_search_v2(query, limit)
      gz = Zlib::GzipReader.new(StringIO.new(resp.body.to_s))
      uncompressed_string = gz.read
      Rails.logger.debug "======response======#{resp.inspect}============="
      @add_data = add_to_outscrapper_requests(JSON.parse(uncompressed_string), resp.env.url, lead_source_id, [], [], [], limit, [])
    end
    if @add_data
      render json: {code: 200, response: "Created"}
    else
      render json: {code: 422, response: "Error"}
    end
  end

  def reorder_data
      old_request = current_agency.outscrapper_requests.find_by(id: params[:id])
      if old_request.outscrapper_status != 'Success' or old_request.outscrapper_status != 'Pending'
        begin
          @attempts = old_request.retry_count
          credit_balance = current_agency.outscraper_limit.credit_balance
          request_process = (credit_balance > old_request.limit.to_i)
          if request_process
            resp = OutscrapperService.reorder_search_v2(old_request.request_query)
            gz = Zlib::GzipReader.new(StringIO.new(resp.body.to_s))
            uncompressed_string = gz.read
            update_outscrapper_request(JSON.parse(uncompressed_string), old_request)
          end

        rescue StandardError => e
          Rails.logger.debug e.message

          if (@attempts) < 3
            retry
          end
        end
      end
  end

  def download_data
    request = Outscrapper::Request.find_by(id: params[:outscrapper_request_id])
    @outscrapper_data = request.outscrapper_data.response_json

    attributes = %w[website type email_1 email_2 email_3 email_1_full_name email_2_full_name email_3_full_name instagram company_name phone phone_1
                    phone_2 phone_3 full_address address_line_1 address_line_2 address_zip city state reviews reviews_id reviews_data reviews_link reviews_tags reviews_per_score twitter youtube facebook website_has_fb_pixel website_has_google_tag verified]
    csv_data = CSV.generate(headers: true) do |csv|
      csv << attributes
      @outscrapper_data.each do |data|
        split_address = get_split_address(data["full_address"])
        values = []
        values << data["site"]
        values << data["type"]
        values << (data["email_1"].nil? ? "" : data["email_1"])
        values << (data["email_2"].nil? ? "" : data["email_2"])
        values << (data["email_3"].nil? ? "" : data["email_3"])
        values << (data["email_1_full_name"].nil? ? "" : data["email_1_full_name"])
        values << (data["email_2_full_name"].nil? ? "" : data["email_2_full_name"])
        values << (data["email_3_full_name"].nil? ? "" : data["email_3_full_name"])
        values << data["instagram"]
        values << data["name"]
        values << (data["phone"].nil? ? "" : data["phone"])
        values << (data["phone_1"].nil? ? "" : data["phone_1"])
        values << (data["phone_2"].nil? ? "" : data["phone_2"])
        values << (data["phone_3"].nil? ? "" : data["phone_3"])
        values << (data["full_address"].nil? ? "" : data["full_address"])
        values << split_address[:address_line_1]
        values << split_address[:address_line_2]
        values << split_address[:address_zip]
        values << data["city"]
        values << data["state"]
        values << (data["reviews"].nil? ? "" : data["reviews"])
        values << (data["reviews_id"].nil? ? "" : data["reviews_id"])
        values << (data["reviews_data"].nil? ? "" : data["reviews_data"])
        values << (data["reviews_link"].nil? ? "" : data["reviews_link"])
        values << (data["reviews_tags"].nil? ? "" : data["reviews_tags"])
        values << (data["reviews_per_score"].nil? ? "" : data["reviews_per_score"])
        values << (data["twitter"].nil? ? "" : data["twitter"])
        values << (data["youtube"].nil? ? "" : data["youtube"])
        values << (data["facebook"].nil? ? "" : data["facebook"])
        values << (data["website_has_fb_pixel"].nil? ? "" : data["website_has_fb_pixel"])
        values << (data["website_has_google_tag"].nil? ? "" : data["website_has_google_tag"])
        values << (data['verified'].nil? ? false : data['verified'])
        csv << values
      end
    end
    # total_downloads = current_agency.outscraper_limit.total_downloads

    # if total_downloads < current_agency.outscraper_limit.download_limit
    respond_to do |format|
      format.csv {
        # current_agency.outscraper_limit.update_column(:total_downloads, total_downloads + 1)
        send_data(csv_data, filename: "#{current_agency.name}_external_data_#{request.created_at.strftime("%m-%d-%Y %H_%M_%S")}.csv")
      }
      format.xlsx {
        # current_agency.outscraper_limit.update_column(:total_downloads, total_downloads + 1)
        headers["Content-Disposition"] = "attachment; filename=\"#{current_agency.name}_external_data_#{request.created_at.strftime("%m-%d-%Y %H_%M_%S")}.xlsx\""
      }
      format.json {
        # current_agency.outscraper_limit.update_column(:total_downloads, total_downloads + 1)
        send_data(JSON.pretty_generate(@outscrapper_data), type: 'application/json', disposition: "attachment", filename: "#{current_agency.name}_external_data_#{request.created_at.strftime("%m-%d-%Y %H_%M_%S")}.json")
      }
    end
    # else
    #   flash[:warning] = 'Download limit exceeds'
    #   head :no_content
    # end
  end

  def upload_redymode_data
    if current_agency&.readymode_url.blank?
      @message = { status: 400, message: "No ReadyMode URL Found" }
      return
    end
    request = Outscrapper::Request.find_by(id: params[:id])
    if request.blank?
      @message = { status: 400, message: "Outscrapper Request is not found"}
      return
    end
    unless request.outscrapper_status == "Success"
      request.update(readymode_upload_status: :failed)
      @message = { status: 400, message: "Outscrapper Request is not Success"}
      return
    end
    request.update(readymode_upload_status: :processing)
    ReadymodeLeadUploadJob.perform_async(request.id, current_agency.id)
    @message = { status: 200, message: "Data Uploading..."}
  end

  private

  def add_to_outscrapper_requests(response, query, lead_source_id, categories_array, states_array, cities_array, limit, zip_codes)
    begin
      ActiveRecord::Base.connection.execute 'SET statement_timeout = 5000' # 5 seconds
      outscrapper_request = current_agency.outscrapper_requests.new(
        external_requests_id: response["id"],
        outscrapper_status: response["status"],
        request_query: query,
        categories: categories_array,
        states: states_array,
        cities: cities_array,
        limit: limit,
        lead_source_id: lead_source_id,
        zip_codes: zip_codes.join(", "),
        created_by: current_user.id
      )
    ensure
      ActiveRecord::Base.connection.execute 'SET statement_timeout = 0' # 0 seconds
    end

    begin
      if outscrapper_request.save!
        lead_source = LeadSource.find_by(id: lead_source_id)
        RequestAddMailer.request_added(outscrapper_request, lead_source).deliver_now
        CheckOutscrapperWebhookJob.perform_in(30.minute, outscrapper_request.external_requests_id, lead_source_id)
        CheckFailedOutscrapperWebhookJob.perform_in(40.minute, outscrapper_request.external_requests_id)
      end
      data_added = true
    rescue ActiveRecord::StatementInvalid => e
      Raven.capture_exception(e)
      Rails.logger.debug "=============Error in Outscraper API call============"
      Rails.logger.debug "=============Error : #{e.message}============"
      data_added = false
    end
    data_added
  end

  def update_outscrapper_request(response, old_request)
    if old_request.update(external_requests_id: response["id"], outscrapper_status: response["status"], retry_count: old_request.retry_count + 1)
      lead_source = LeadSource.find_by(id: old_request.lead_source_id)
      RequestAddMailer.request_added(old_request, lead_source).deliver_now
      CheckOutscrapperWebhookJob.perform_in(30.minute, old_request.external_requests_id, lead_source.id)
      CheckFailedOutscrapperWebhookJob.perform_in(40.minute, old_request.external_requests_id)
    end
  rescue ActiveRecord::StatementInvalid => e
    Raven.capture_exception(e)
    Rails.logger.debug "=============Error in Outscraper API call============"
    Rails.logger.debug "=============Error : #{e.message}============"
  end

  def get_query_combination(categories_array, states_array, cities_array, zip_codes)
    country = ["USA"]
    if cities_array.nil?
      categories_array.product(country, states_array)
    elsif zip_codes.empty?
      filtered_data(categories_array.product(cities_array, states_array))
    else
      categories_array.product(cities_array, zip_codes)
    end
  end

  def get_split_address(full_address)
    if full_address.present?
      result = Indirizzo::Address.new(full_address)
      {
        address_line_1: result.street[0],
        address_line_2: result.street[1],
        address_zip: result.zip
      }
    else
      {
        address_line_1: '',
        address_line_2: '',
        address_zip: ''
      }
    end
  end

  def filtered_data(data)
    wrong_pairs = []
    data.each do |d|
      unless CS.cities(d[2], :us).include?(d[1])
        wrong_pairs << d
      end
    end
    data - wrong_pairs
  end
end
