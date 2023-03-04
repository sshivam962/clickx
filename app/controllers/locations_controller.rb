# frozen_string_literal: true

class LocationsController < ApplicationController
  include BrightLocal

  before_action :get_current_user, except: %w[get_all_locations]
  before_action :set_location,
                except: %w[get_all_locations create update index
                           local_profile_locations get_service_location
                           brightlocal_locations locations_with_average_rating]
  before_action :set_current_business,
                except: %w[get_all_locations get_service_location update]
  before_action -> { current_user.super_admin? || authorize(@business, :client_level_manage?) },
                except: %w[get_all_locations get_service_location update set_yext_id]
  def get_all_locations
    render json: Location.all.to_json(map_info: true)
  end

  def index
    @locations = @business.locations.includes(%i[social_links business])
    render json: @locations.to_json
  end

  def locations_with_average_rating
    @locations = @business.locations.includes(:social_links, :business)
    @locations.each do |loc|
      begin
        avg = loc.reviews.sum(:rating) / loc.reviews.where('rating > 0').count
        avg = avg.nan? ? 0.0 : avg
      rescue ZeroDivisionError
        avg = 0.0
      end
      loc.update_attributes(average_rating: avg)
    end
    render json: @locations.to_json
  end

  def show
    render json: @location.to_json
  end

  def create
    @location = @business.locations.new(location_params)
    @location.current_user = current_user
    if @location.save
      render json: { status: 201, location: @location }
    else
      render json: { status: 406, location: @location,
                     errors: @location.errors }
    end
  end

  def edit
    render json: @location.to_json
  end

  def update
    @location = Location.find(params[:id])
    @location.current_user = current_user
    if @location.update_attributes(location_params)
      render json: { status: 200, location: @location }
    else
      render json: { status: 406, location: @location,
                     errors: @location.errors }
    end
  end

  def destroy
    if @location.destroy
      render json: { status: 200 }
    else
      render json: { status: 406, location: @location, errors: @location.errors }
    end
  end

  def scan
    site_id = params[:site_id]
    resp = YextApi.new(@business.yext_creds)
                  .powerlistings_scan(site_id, @location.address_fields)
    response = ActiveSupport::JSON.decode(resp.body)

    unless resp.status.eql? 200
      begin
        @response = response['errors'].first['message'].split(':').last.strip
      rescue StandardError
        'Temporary problem scanning on this publisher.'
      end
    end

    directory = begin
                  REVIEW_DIRS[site_id]['directory']
                rescue StandardError
                  ''
                end
    render json: { status: resp.status,
                   body: @response || response,
                   site_id: site_id,
                   directory: directory }
  end

  def local_profile_locations
    business_locations = @business.locations
    locations = business_locations
    render json: locations.to_json(for_local_profile: true)
  end

  def get_service_location
    location = Location.find(params[:id])
    render json: location.to_json
  end

  def export_csv
    @location = Location.find(params[:id])
    send_data @location.to_csv,
              disposition: 'attachment',
              filename: "locations_#{Time.current.strftime('%Y%m%d')}.csv"
  end

  def set_yext_id
    @location.update_attribute(:yext_store_id, params[:yext_id]) if params[:yext_id]
    render json: { status: 200, location: @location }
  end

  def set_brightlocal_id
    if params[:brightlocal_id]
      @location.update_attribute(:bright_local_report_id,
                                 params[:brightlocal_id])
    end
    render json: { status: 200, location: @location }
  end

  def yext_listings
    if @business.local_profile_service
      data = fetch_yext_data
      render json: { status: 200, data: data }
    else
      render json: { status: 406, business: @business,
                     errors: 'Business not yet opted for local profile.' }
    end
  rescue StandardError
    render json: { status: 406, business: @business,
                   errors: 'Error in fetching local profile data.' }
  end

  def yext_info
    if @business.local_profile_service
      data = fetch_yext_info
      render json: { status: 200, data: data }
    else
      render json: { status: 406, business: @business,
                     errors: 'Business not yet opted for local profile.' }
    end
  rescue StandardError
    render json: { status: 406, business: @business,
                   errors: 'Error in fetching location data.' }
  end

  def brightlocal_locations
    locations = @business.locations.includes(:social_links, :business)
                         .brightlocal
    render json: locations.to_json
  end

  def reviews
    render json: { status: 200, data: @location.reviews.order_dsc }
  end

  def sitewise_reviews
    data = @location.reviews.group(:name, :directory)
                    .select('name, directory, CAST(AVG(rating) AS DECIMAL(10,2)) as rating, COUNT(*) as reviews')
    render json: { status: 200, data: data }
  end

  def star_counts
    render json: { status: 200, data: get_reviews_star_count }
  end

  def reviews_count
    render json: { status: 200, data: @location.reviews_count }
  end

  def reviews_growth
    render json: { status: 200, data: get_reviews_growth }
  end

  def dir_reviews
    render json: { status: 200,
                   data: @location.reviews.directory(params[:dir]).order_dsc }
  end

  def reviews_by_stars
    render json: { status: 200,
                   data: @location.reviews.rating(params[:star_count])
                                  .order_dsc }
  end

  def top_reviews
    @reviews = if params[:limit]
                 @location.reviews.top_rated.order_dsc.first(params[:limit])
               else
                 @location.reviews.top_rated.order_dsc
               end

    render pdf: 'top_reviews',
           layout: 'review_pdf', template: 'locations/new_top_reviews.html.haml',
           show_as_html: params.key?('debug'),
           margin: { top: 0, bottom: 0, left: 0, right: 0 }
  end

  def set_bright_local_campaign_id
    if params[:bright_local_campaign_id]
      @location.update_attribute(:bright_local_campaign_id,
                                 params[:bright_local_campaign_id])
    end
    render json: { status: 200, location: @location } and return
  end

  def bright_local_listings
    if @business.local_profile_service
      data = fetch_bright_local_data
      render json: { status: 200, data: data }
    else
      render json: { status: 406, business: @business,
                     errors: 'Business not yet opted for local profile.' }
    end
  rescue StandardError
    render json: { status: 406, business: @business,
                   errors: 'Error in fetching local profile data.' }
  end

  private

  def get_reviews_star_count
    rating = { '0star' => 0, '1star' => 0, '2star' => 0,
               '3star' => 0, '4star' => 0, '5star' => 0 }

    ratings = @location.reviews.pluck :rating
    ratings.each_with_object(rating) { |key, h| h["#{key.to_i}star"] += 1 }
  end

  def get_reviews_growth
    reviews_data = if @location.update_yext_reviews?
                     @location.yext_reviews_info
                   else
                     @location.bl_reviews_info
                   end

    latest_total = @location.reviews_count || 0
    prev_total = begin
                   @location.reviews.where('timestamp <= ?', reviews_data['count_prev_updated_at'].to_date).count
                 rescue StandardError
                   latest_total
                 end

    growth = ((latest_total - prev_total) * 100.0) / prev_total
    growth = 0 if growth.nan? || growth.infinite?

    { 'percent' => growth,
      'number' => (latest_total - prev_total) }
  end

  def set_location
    @location = Location.find(params[:id])
  end

  def fetch_yext_data
    listings_data = @location.yext_listings
    updated_at = begin
                   listings_data['data_updated_at'].to_datetime
                 rescue StandardError
                   nil
                 end

    if updated_at.present? && ((updated_at + 24.hours) > Time.current)
      data = listings_data['data']
    else
      data = YextApi.new(@business.yext_creds)
                    .powerlistings(@location.yext_store_id)

      listings_data = { 'data' => data, 'data_updated_at' => Time.current }
      @location.yext_listings = listings_data
      @location.save
    end
    data
  end

  def fetch_yext_info
    yext_info = @location.yext_info
    updated_at = begin
                   yext_info['data_updated_at'].to_datetime
                 rescue StandardError
                   nil
                 end

    if updated_at.present? && ((updated_at + 24.hours) > Time.current)
      data = yext_info['data']
    else
      data = YextApi.new(@business.yext_creds)
                    .location_info(@location.yext_store_id)
      yext_info = { 'data' => data, 'data_updated_at' => Time.current }

      @location.yext_info = yext_info
      @location.save
    end
    data
  end

  def fetch_bright_local_data
    listings_data = @location.bright_local_lisiting
    updated_at = begin
                   listings_data['data_updated_at'].to_datetime
                 rescue StandardError
                   nil
                 end

    if updated_at.present? && ((updated_at + 24.hours) > Time.current)
      data = listings_data['data']
    else
      data = citation_burst(@location.bright_local_campaign_id)
      listings_data = { 'data' => data, 'data_updated_at' => Time.current }
      @location.bright_local_lisiting = listings_data
      @location.save
    end
    data
  end

  def location_params
    # FIXME: using except! is a security issue, to_h is just a workaround to make it works with rails5
    unless params[:location][:social_links_attributes]
      params[:location][:social_links_attributes] = params[:location][:social_links] if params[:location][:social_links].present?
      params[:location].to_unsafe_hash.except!(:social_links, :files, :newLogo, :is_new,
                                               :local_profile_enabled, :new_local_profile_list)
    end

    unless params[:location][:business_hours_attributes]
      params[:location][:business_hours_attributes] = params[:location][:working_hours] if params[:location][:working_hours].present?
      params[:location].to_unsafe_hash.except!(:working_hours)
    end

    unless params[:location][:review_links_attributes]
      params[:location][:review_links_attributes] =
        params[:location][:review_links] if params[:location][:review_links].present?
    end

    params.require(:location)
          .permit(:id, :name, :address, :state, :city, :country,
                  :zip, :phone, :mobile_phone, :toll_free, :website,
                  :enquiry_email, :fax, :local_profile_list,
                  :slogan, :keywords, :short_description,
                  :medium_description, :full_description,
                  :long_description, :number_of_users, :year_established,
                  :local_profile_last_upload, :user_id, :business_id,
                  :operational_hours, :positive_review_coupon,
                  :negative_review_coupon, :contact_name,
                  social_links_attributes: %i[id _destroy link_type
                                              link location_id],
                  review_links_attributes: %i[id _destroy link_type
                                              link location_id],
                  business_hours_attributes: %i[id days from to status],
                  images: [], files: [], categories: [], payment_methods: [],
                  products_services: [], professional_associations: [],
                  brands: [], languages: [])
  end

  def set_current_business
    @business = if current_user.super_admin?
                  @location&.business || current_business
                else
                  current_business
                end
  end
end
