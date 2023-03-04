# frozen_string_literal: true

class Agency::LeadSourcesController < Agency::BaseController
  before_action :set_lead_source, only: %i[show edit update enable disable autopilot_send_contacts]

  def index
    @agency = current_agency
    @lead_sources = @agency.lead_sources.order_by_created.paginate(page: params[:page], per_page: 10)
  end

  def buy_data_requests
    outscrapper_requests = current_agency.outscrapper_requests.includes([:outscrapper_data]).where(outscrapper_status: 'Success')
    outscrapper_requests.each do |request|
    request.update_column(:outscrapper_status, 'Failed') if request.outscrapper_data.nil? && request.outscrapper_status == 'Success'
    end
    @outscrapper_requests = current_agency.outscrapper_requests.paginate(page: params[:page], per_page: 10)
  end

  def search_outscrapper_categories
    categories = Outscrapper::Category.where(
      "category ILIKE ?", "#{params[:search]}%"
    ).select(:category, :id).first(100)

    categories_collection = categories.map do |category|
      { id: category.category, text: category.category }
    end

    render json: { categories: categories_collection }
  end

  def delete_data_requests
    outscrapper_request = current_agency.outscrapper_requests.find_by(id: params[:id])
    outscrapper_request.destroy

    redirect_to buy_data_requests_agency_lead_sources_path
  end

  def show
    params[:per_page] ||= 20
    @direct_leads = @lead_source.direct_leads.where('name ILIKE :name',
      name: "%#{params[:search]}%").paginate(page: params[:page], per_page: params[:per_page])
    @agency_email_templates = current_agency.email_templates.enabled
  end

  def create
    @message = [true]
    @lead_sources = current_agency.lead_sources.order_by_created
    return @message unless @message[0]
    @lead_source = current_agency.lead_sources.create(lead_source_params)
    @message = if @lead_source.persisted?
                  [true, 'Lead Source created successfully']
               else
                  [false, @lead_source.errors.full_messages.to_sentence]
               end
  end

  def edit
    @agency = @lead_source.agency
  end

  def update
    @message = [true]
    @lead_sources = current_agency.lead_sources.order_by_created
    return @message unless @message[0]
    @message = if @lead_source.update(update_params)
      [true, 'Lead Source updated successfully']
    else
       [false, @lead_source.errors.full_messages.to_sentence]
    end
  end

  def destroy
    @lead_source = LeadSource.find(params[:id])
    @message = if @lead_source.destroy
                 @deleted = true
                 'LeadSource deleted successfully'
               else
                 @lead_source.errors.full_messages.to_sentence
               end
  end

  def enable
    @lead_source.update(enabled: true)
  end

  def disable
    @lead_source.update(enabled: false)
  end

  def cities
    @outscrapper_state = params[:outscrapper_data][:state] unless params[:outscrapper_data].nil?
  end

  def activate_autopilot
    @list = LeadSource.where(id: params['id'],agency_id: params['agency_id']).first
    return if @list.blank?
    @list.toggle!(:enable_automate)
  end

  def autopilot_send_contacts
    @message = "No List Found"
    return @message if @lead_source.blank?
    direct_lead_ids = @lead_source.direct_leads.pluck(:id)
    @message = "No Lead found"
    return @message if direct_lead_ids.blank?
    @message = "Already send the emails"
    return @message unless ColdEmailBatch.where("name = ? and lead_source_id = ?", "Batch_#{Time.now.strftime("%Y_%m_%d")}", @lead_source.id).any?
    if DomainContact.where("email_opened_at is null and email_sent_at is null and direct_lead_id in (?)", direct_lead_ids).any? &&
        current_agency.email_leads_count_limit >=  current_agency.send_email_leads_count
      ProcessAutopilotEmailJob.perform_async(@lead_source.id, current_user.id, direct_lead_ids)
    end
    @message = "Successfully Initiated Emails sending"
  end

  private

  def lead_source_params
    @params ||= params.require(:lead_source)
                      .permit(:name, :from_email_name)
    @params
  end

  def set_lead_source
    @lead_source = LeadSource.find(params[:id])
  end

  def update_params
    params.require(:lead_source).permit(
      :email_template,
      :subject,
      :name,
      :sequence_id,
      :closeio_user_id,
      :batch_size,
      :from_email_name,
      :word_press,
      lead_source_email_templates_attributes: [
        :id,
        :email_template_id,
        :subject,
        :_destroy
      ]
    )
  end

end
