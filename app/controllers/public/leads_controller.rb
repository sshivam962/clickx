# frozen_string_literal: true

class Public::LeadsController < PublicController
  before_action :set_agency

  layout 'leads'

  def create
    render :new and return if request.get?

    @lead = @agency.leads.create(lead_params)
    @redirect_url = lead_registration_redirect
    @error = @lead.errors.full_messages.to_sentence if @lead.errors.present?
  rescue StandardError => e
    @error = e.message
  end

  private

  def set_agency
    @agency = Agency.find_by(name_slug: params[:agency_slug])
  end

  def lead_params
    params.require(:lead).permit(
      :first_name, :last_name, :email, :company, :domain, :phone, :status,
      :value, :goals_and_expectations, :comment, :next_meeting_date,
      :audit_request
    ).merge(additional_lead_params)
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

  def lead_registration_redirect
    @agency.kickoff_call_link.presence || LEAD_REGISTRATION_CALENDLY_LINK.presence || register_lead_path(agency_slug: @agency.name_slug)
  end
end
