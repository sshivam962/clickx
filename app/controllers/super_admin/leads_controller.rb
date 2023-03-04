# frozen_string_literal: true

class SuperAdmin::LeadsController < ApplicationController
  layout 'base'
  before_action :perform_authorization
  before_action :set_lead, only: [:show, :edit, :update, :info, :old_strategy]

  def index
    @leads =
      ::Lead.includes(:agency).where(search_query)
            .reorder(created_at: :desc)
            .paginate(page: params[:page], per_page: 20)

    if request.format.json?
      content = render_to_string(partial: 'super_admin/leads/shared/list')
    end

    respond_to do |format|
      format.json do
        render json: { status: 200, data: content }
      end
      format.html {}
    end
  end

  def export_csv
    attributes = ::Lead.csv_default_attributes & params[:attributes]
    send_data ::Lead.to_csv(attributes), filename: "leads-#{Date.current}.csv"
  end

  def show; end

  def info; end

  def edit; end

  def update
    if @lead.update(lead_params)
      redirect_to super_admin_leads_path
    else
      render :edit
    end
  end

  def old_strategy
    @lead.update_columns(old_strategy: true)
  end

  private

  def lead_params
    params.require(:lead).permit(
      :first_name, :last_name, :email, :company, :domain, :phone, :status,
      :value, :goals_and_expectations, :comment, :audit_request
    ).merge(additional_lead_params).merge(next_meeting_date_params)
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

  def next_meeting_date_params
    {
      next_meeting_date:
      Date.strptime(params[:lead][:next_meeting_date], "%m-%d-%Y")
    } if params[:lead][:next_meeting_date].present?
  end

  def set_lead
    @lead = ::Lead.find(params[:id])
  end

  def perform_authorization
    authorize %i[super_admin lead]
  end

  def search_query
    return '' if params[:name].blank? && params[:agency].blank?

    q = []
    if params[:name].present?
      q.push("(CONCAT_WS(' ', lower(leads.first_name), lower(leads.last_name)) ILIKE '%#{params[:name]}%' OR lower(leads.email) ILIKE '%#{params[:name]}%' OR lower(leads.domain) ILIKE '%#{params[:name]}%')")
    end
    if params[:agency].present?
      q.push("leads.agency_id = #{params[:agency]}")
    end
    q.join(' AND ')
  end
end
