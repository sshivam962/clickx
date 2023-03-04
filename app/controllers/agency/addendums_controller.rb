class Agency::AddendumsController < Agency::BaseController
  layout 'agreement'

  before_action :set_agency
  before_action :check_addendum, only: %i[new create]
  before_action :find_or_create_addendum, only: :create

  def new
    redirect_to root_path if current_agency.addendum_signed?
  end

  def show
    @agreement = @agency.agreement
  end

  def create
    pdf = AgencyAddendumPdfGenerator.run(pdf_generator_params)
    pdf_file_name = "public/addendums/#{@agency.name.parameterize}.pdf"
    pdf.render_file(pdf_file_name)
    @addendum.update(file: File.open(pdf_file_name), signed: true)
    @addendum.reload
  rescue Exception => e
    @error = e.message
  end

  def download
    send_data(
      open(@agency.addendum.file.url).read,
      filename: 'addendum.pdf',
      type: 'application/pdf',
      disposition: 'attachment'
    )
  end

  private

  def check_addendum
    return if !current_agency.addendum_signed?

    redirect_to root_path
  end

  def set_agency
    @agency = current_agency
  end

  def pdf_generator_params
    {
      addendum: pdf_data.merge(signature: @addendum.reload.signature.url)
    }
  end

  def pdf_data
    params.require(:addendum).permit(
      :name, :title, :signature, :agency_name
    )
  end

  def find_or_create_addendum
    @addendum =
      if @agency.addendum
        @agency.addendum.update(signature: pdf_data[:signature])
        @agency.addendum
      else
        @agency.create_addendum(signature: pdf_data[:signature])
      end.reload
  end
end
