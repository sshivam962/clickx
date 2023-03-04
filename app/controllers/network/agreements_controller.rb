class Network::AgreementsController < Network::BaseController
  before_action :set_network
  before_action :check_agreement, only: %i[new create]
  before_action :find_or_create_agreement, only: :create
  skip_before_action :check_agreement_signed

  def new
  end

  def show
    @agreement = @network.agreement
  end

  def create
    pdf = NetworkAgreementPdfGenerator.run(pdf_generator_params)
    @network.update(legal_name: pdf_data[:legal_name])
    pdf_file_name = "public/agreements/#{current_user.name.parameterize}.pdf"
    pdf.render_file(pdf_file_name)
    @agreement.update(file: File.open(pdf_file_name), signed: true)
    @agreement.reload

    redirect_to root_path
  rescue Exception => e
    @error = e.message
  end

  def download
    send_data(
      open(@network.agreement.file.url).read,
      filename: 'agreement.pdf',
      type: 'application/pdf',
      disposition: 'attachment'
    )
  end

  private

  def check_agreement
    redirect_to root_path unless agreement_redirect_needed?
  end

  def set_network
    @network = current_user.network_profile
  end

  def pdf_generator_params
    {
      agreement: pdf_data.merge(signature: @agreement.reload.signature.url)
    }
  end

  def pdf_data
    params.require(:agreement).permit(
      :legal_name, :name, :signature
    )
  end

  def find_or_create_agreement
    @agreement =
      if @network.agreement
        @network.agreement.update(signature: pdf_data[:signature])
        @network.agreement
      else
        @network.create_agreement(signature: pdf_data[:signature])
      end.reload
  end
end
