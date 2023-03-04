class Business::LocationsController < Business::BaseController
  before_action :set_location, only: %i[edit update destroy]

  def index
    @locations = current_business.locations.includes(%i[social_links business])
  end

  def new
    @location = Location.new
  end

  def create
    @location = current_business.locations.new(location_params)
    @location.current_user = current_user
    @location.save

    redirect_to business_locations_path
  end

  def update
    @location.assign_attributes(location_params)
    @location.current_user = current_user
    @location.save

    redirect_to business_locations_path
  end

  def destroy
    @location.destroy

    redirect_to business_locations_path
  end

  private

  def set_location
    @location = current_business.locations.find(params[:id])
  end

  def location_params
    # FIXME: using except! is a security issue, to_h is just a workaround to make it works with rails5
    unless params[:location][:social_links_attributes]
      params[:location][:social_links_attributes] = params[:location][:social_links] if params[:location][:social_links].present?
      params[:location].to_unsafe_hash.except!(:social_links, :files, :newLogo, :is_new,
                                               :local_profile_enabled, :new_local_profile_list)
    end

    unless params[:location][:business_hours_attributes]
      params[:location][:working_hours].values.each do |hour|
        hour['from'] = hour['from_1'].to_s + hour['from_2'].to_s
        hour['to'] = hour['to_1'].to_s + hour['to_2'].to_s
      end
      params[:location][:business_hours_attributes] = params[:location][:working_hours].values if params[:location][:working_hours].present?
      params[:location].to_unsafe_hash.except!(:working_hours)
    end

    unless params[:location][:review_links_attributes]
      if params[:location][:review_links].present?
        params[:location][:review_links_attributes] =
          params[:location][:review_links]
      end
    end

    # rubocop:disable Style/RescueModifier
    params[:location][:brands] =
      params[:location][:brands].split(",").map(&:strip) rescue []
    params[:location][:languages] =
      params[:location][:languages].split(",").map(&:strip) rescue []
    params[:location][:products_services] =
      params[:location][:products_services].split(",").map(&:strip) rescue []
    params[:location][:professional_associations] =
      params[:location][:professional_associations].split(",").map(&:strip) rescue []
    # rubocop:enable Style/RescueModifier

    params.require(:location).permit(
      :id, :name, :address, :state, :city, :country, :zip,
      :phone, :mobile_phone, :toll_free,
      :website, :enquiry_email, :fax, :local_profile_list,
      :slogan, :keywords, :short_description,
      :medium_description, :full_description,
      :long_description, :number_of_users, :year_established,
      :local_profile_last_upload, :user_id, :business_id,
      :operational_hours, :positive_review_coupon,
      :negative_review_coupon, :contact_name,
      social_links_attributes: %i[id _destroy link_type link location_id],
      review_links_attributes: %i[id _destroy link_type link location_id],
      business_hours_attributes: %i[id days from to status],
      images: [], files: [], categories: [], payment_methods: [], brands: [],
      products_services: [], professional_associations: [], languages: []
    )
  end
end
