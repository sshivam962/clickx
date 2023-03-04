# frozen_string_literal: true

class Agency::ClientsController < Agency::BaseController
  before_action :set_client,
                only: %i[
                  questionnaires email_settings edit update destroy lead_info
                  add_keywords
                ]

  # before_action :ensure_access, only: %i[new create]

  def index
    @demo_client = Business.birch_homes
    @clients = current_agency.businesses.includes(:users, :lead)
                             .select(:id, :name, :logo)
                             .where(search_query)
                             .order(:name)
                             .paginate(page: params[:page], per_page: 20)
  end

  def new
    @client = current_agency.businesses.new(target_city: 'United States')
  end

  def create
    @client = current_agency.businesses.create(client_params)

    redirect_to agency_clients_path
  end

  def questionnaires
    @questionnaires = @client.questionnaires_with_links
  end

  def email_settings; end

  def edit; end

  def update
    save_logo if params[:business][:logo].present?
    if @client.update(client_params)
      flash[:success] = 'Client Updated'
      redirect_to agency_clients_path
    else
      flash[:error] = @client.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    deleted_business_params = [@client.id, @client.name, @client.locale]
    if @client.update(deleted_at: Time.current)
      BusinessOnDeleteSendDetailsJob.perform_async(*deleted_business_params)
    end
  end

  def lead_info
    @lead = @client.lead
  end

  def add_keywords
    @client.update(client_params)
    params[:keywords].split(/\r\n/).compact.uniq.each do |keyword|
      @client.keywords.find_or_create_by(name: keyword)
    end
  end

  private

  def set_client
    @client = Business.find(params[:id])
  end

  def search_query
    return '' if params[:q].blank?

    "lower(businesses.name) ILIKE '%#{params[:q]}%'"
  end

  def client_params
    params.require(:business).permit(
      :name, :target_city, :seo_service, :keyword_limit, :site_audit_service,
      :backlink_service, :call_analytics_service, :contents_service,
      :competitors_service, :competitors_limit,
      :timezone, :domain, :id,
      :reputation_service, :locale
    )
  end

  def save_logo
    @client.logo =
      Cloudinary::Uploader.upload(
        params[:business][:logo], options = {}
      )['secure_url']
    @client.save
  end

  def ensure_access
    return if original_user.super_admin?

    redirect_to agency_clients_path
  end
end
