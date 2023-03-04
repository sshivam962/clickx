class Agency::EmailTemplatesController < Agency::BaseController
  # before_action :perform_authorization
  before_action :set_email_template, only: %i[edit update]

  def index
    @email_templates = current_agency.email_templates.enabled
  end

  def new
    @email_template = current_agency.email_templates.new
  end

  def create
    @email_template = current_agency.email_templates
                                    .create(email_template_params)

    if @email_template.persisted?
      redirect_to agency_email_templates_path, notice: 'Email template was successfully created.'
    else
      render :new
    end
  end

  def edit
    @email_template = current_agency.email_templates.find(params[:id])
  end

  def update
    if @email_template.update(email_template_params)
      redirect_to agency_email_templates_path, notice: 'Email template was successfully updated.'
    else
      render :edit
    end
  end

  def create_duplicate_email_template
    @email_template = current_agency.email_templates.find(params[:id])
    new_email_template = current_agency.email_templates.new(@email_template.attributes.except('id'))
    new_email_template.name = "Copy of #{new_email_template.name}"
    new_email_template.save
    redirect_to agency_email_templates_path, notice: 'Duplicate email template was successfully created.'  
  end

  def disable_email_template
    @email_template = current_agency.email_templates.find(params[:id])
    return redirect_to agency_email_templates_path if @email_template.blank?
    lead_source_names = @email_template.lead_source_email_templates.joins(:lead_source)
      .select("lead_sources.name as lead_source_name").map(&:lead_source_name)
    if lead_source_names.present?
      @email_template_response =
        { status: 400, message: "Please remove email template from the list",
          lead_source_names: lead_source_names}
      return
    end
    @email_template.update(enabled: false)
    @email_template_response =
      { status: 200,
        id: @email_template.id,
        message: 'Email template was successfully removed.' }
  end  

  private

  def email_template_params
    params.require(:email_template).permit(
      :name,
      :subject,
      :content,
      :wordpress_site_custom_content
    )
  end

  def set_email_template
    @email_template = current_agency.email_templates.find(params[:id])
  end
end
