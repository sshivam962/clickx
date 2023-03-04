class Business::AgreementsController < Business::BaseController
  layout 'agreement'

  before_action :set_client
  before_action :check_agreement, only: %i[new create]
  before_action :find_or_create_agreement, only: :create

  def new
    redirect_to root_path if current_business.agreement_signed?
  end

  def show
    @agreement = @client.agreement
  end

  def create
    pdf = ClientAgreementPdfGenerator.run(pdf_generator_params)
    @client.update(legal_name: pdf_data[:legal_name])
    pdf_file_name = "public/agreements/#{@client.name.parameterize}.pdf"
    pdf.render_file(pdf_file_name)
    @agreement.update(file: File.open(pdf_file_name), signed: true)
    @agreement.reload
    AgreementMailer.business(@agreement, current_user).deliver_later
    AdminMailer.business_agreement(@agreement, current_user).deliver_later
  rescue Exception => e
    @error = e.message
  end

  def download
    send_data(
      open(@client.agreement.file.url).read,
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

  def set_client
    @client = current_business
  end

  def pdf_generator_params
    {
      agreement: pdf_data.merge(signature: @agreement.reload.signature.url)
    }
  end

  def pdf_data
    params.require(:agreement).permit(
      :legal_name, :name, :title, :signature
    )
  end

  def find_or_create_agreement
    @agreement =
      if @client.agreement
        @client.agreement.update(signature: pdf_data[:signature])
        @client.agreement
      else
        @client.create_agreement(signature: pdf_data[:signature])
      end.reload
  end
end
