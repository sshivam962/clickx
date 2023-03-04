class Agency::AgreementsController < Agency::BaseController
  layout 'agreement'

  before_action :set_agency
  before_action :check_agreement, only: %i[new create]
  before_action :find_or_create_agreement, only: :create

  def new
    redirect_to root_path if current_agency.agreement_signed?
  end

  def show
    @agreement = @agency.agreement
  end

  def create
    pdf = AgencyAgreementPdfGenerator.run(pdf_generator_params)
    @agency.update(legal_name: pdf_data[:legal_name])
    pdf_file_name = "public/agreements/#{@agency.name.parameterize}.pdf"
    pdf.render_file(pdf_file_name)
    @agreement.update(file: File.open(pdf_file_name), signed: true, version: 'v2')
    @agreement.reload
    AgreementMailer.agency(@agreement, current_user).deliver_later
    AdminMailer.agency_agreement(@agreement, current_user).deliver_later
  rescue Exception => e
    @error = e.message
  end

  def download
    send_data(
      open(@agency.agreement.file.url).read,
      filename: 'agreement.pdf',
      type: 'application/pdf',
      disposition: 'attachment'
    )
  end

  private

  def check_agreement
    return if agreement_not_signed?

    redirect_to root_path
  end

  def set_agency
    @agency = current_agency
  end

  def pdf_generator_params
    {
      agreement: pdf_data.merge(signature: @agreement.reload.signature.url)
    }
  end

  def pdf_data
    params.require(:agreement).permit(
      :legal_name, :location, :name, :title, :signature
    )
  end

  def find_or_create_agreement
    @agreement =
      if @agency.agreement
        @agency.agreement.update(signature: pdf_data[:signature])
        @agency.agreement
      else
        @agency.create_agreement(signature: pdf_data[:signature])
      end.reload
  end
end
