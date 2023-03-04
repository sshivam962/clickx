class Agency::LeadsController < Agency::BaseController
  before_action :perform_authorization
  before_action :set_lead,
                only: %i[edit show update destroy default_strategies strategies]
  before_action :set_deleted_lead, only: %i[unarchive force_delete]

  def index
    search_string = []
    columns.each do |term|
      search_string << "#{term} ilike :search"
    end
    @leads = current_agency.leads.where(search_string.join(" or "), search: "%#{search_keyword.strip}%")
                           .reorder(updated_at: :desc)
                           .paginate(per_page: 20, page: params[:page])
  end

  def archived
    @leads = current_agency.leads.only_deleted.where(search_query_sql, search: "%#{search_keyword.strip}%")
                           .reorder(updated_at: :desc)
                           .paginate(per_page: 20, page: params[:page])
  end

  def unarchive
    @lead&.restore(recursive: true)
  end

  def force_delete
    @lead&.really_destroy!
  end

  def show; end

  def new
    @lead = current_agency.leads.new
  end

  def edit; end

  def create
    @lead = current_agency.leads.new(lead_params)
    if @lead.save
      Notifier.lead_create_mail(@lead.id, current_agency.id, current_user.id)
              .deliver_later
      @redirect_url = agency_leads_path
    else
      @error = @lead.errors.full_messages.to_sentence
    end
  rescue StandardError => e
    @error = e.message
  end

  def update
    if @lead.update(lead_params)
      @redirect_url = agency_leads_path
    else
      @error = @lead.errors.full_messages.to_sentence
    end
  rescue StandardError => e
    @error = e.message
  end

  def destroy
    @lead.destroy
  end

  def default_strategies; end

  def strategies
    @strategies = @lead.lead_strategies.with_deleted.group_by(&:category)
    @strategy_limit = current_agency.strategy_limit
    @this_month_strategies = current_agency.this_month_strategies
  end

  private

  def set_lead
    @lead = current_agency.leads.find(params[:id])
  end

  def set_deleted_lead
    @lead = current_agency.leads.only_deleted.find_by_id(params[:id])
  end

  def lead_params
    params.require(:lead).permit(
      :first_name, :last_name, :email, :company, :domain, :phone, :status,
      :value, :goals_and_expectations, :comment, :audit_request
    ).merge(additional_lead_params).merge(next_meeting_date_params)
  end

  def next_meeting_date_params
    {
      next_meeting_date:
        Date.strptime(params[:lead][:next_meeting_date], "%m-%d-%Y")
    } if params[:lead][:next_meeting_date].present?
  end

  def additional_lead_params
    {
      campaign_info: params[:lead][:campaign_info]&.keys,
      next_steps: params[:lead][:next_steps]&.keys,
      competitor_info: params[:lead][:competitor_info],
      call_notes: params[:lead][:call_notes],
      current_info: params[:lead][:current_info]
    }
  end

  def perform_authorization
    authorize current_agency, :leads?
  end

  def search_keyword
    params[:name] || ""
  end

  def search_query_sql
    search_string = []
    columns.each do |term|
      search_string << "#{term} ilike :search"
    end
    search_string.join(" or ")
  end

  def columns
    %w(first_name last_name email company)
  end
end
