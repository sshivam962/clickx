module Public
  class FunnelPagesController < PublicController
    layout 'public/funnel_page'

    before_action :set_funnel_page, only: :show
    before_action :set_agency, only: %i[show create_lead]
    before_action :set_funnel_page_form, only: :show

    def create_lead
      @lead = @agency.leads.new(lead_params)

      if @lead.save
        FunnelNotifierMailer.funnel_lead_create_mail(@lead.id, @agency.id, params["niche_name"])
                .deliver_later
      end  
      if @agency.calendly_script
        render 'public/funnel_pages/thank_you_with_cal'
      else
        @no_header = true
        render 'public/funnel_pages/thank_you'
      end
    end

    private

    def set_funnel_page
      @funnel_page ||= FunnelPage.published.find_obfuscated(params[:id])
    end

    def set_agency
      @agency ||= Agency.find_obfuscated(params[:agency_id])
    end

    def set_funnel_page_form
      @agency_niche = AgencyNiche.find_or_create_by(
        agency_id: @agency.id,
        industry_id: @funnel_page.industry_id
      )
    end

    def lead_params
      params.require(:lead).permit(:first_name, :last_name, :email, :phone)
    end
  end
end
