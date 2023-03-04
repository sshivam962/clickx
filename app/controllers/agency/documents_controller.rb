class Agency::DocumentsController < Agency::BaseController
  before_action :perform_authorization
  before_action :set_document, only: %i[show edit update destroy]
  before_action :set_category

  def index
    @all_documents = Document.agency_documents.includes(
      :document_attachment, :thumbnail
    ).where(category: @category)

    @documents = @all_documents.select do |document|
      document if current_agency.documents.agency_documents.include?(document) || document.agency_id == 0
    end

    @my_documents = current_agency.documents.agency_documents.includes(
      :document_attachment, :thumbnail
    )
  end

  def search
    @all_documents = Document.agency_documents.includes(
      :document_attachment, :thumbnail
    ).where(search_query)

    @documents = @all_documents.select do |document|
      document if current_agency.documents.agency_documents.include?(document) || document.agency_id == 0
    end

    content = render_to_string(
      partial: 'agency/documents/shared/search',
      locals: { documents: @documents }
    )

    render json: { status: 200, message: '', data: { content: content } }
  end

  def new
    @document = Document.new

    @document.build_document_attachment
  end

  def create
    @document = Document.new(document_params)
    if @document.save
      flash[:success] = 'Document updated Successfully'
      redirect_to agency_documents_path
    else
      flash[:error] = @document.errors.full_messages.to_sentence
      redirect_to new_agency_document_path(@document)
    end
  end

  def edit; end

  def update
    if @document.update(document_params)
      flash[:success] = 'Document updated Successfully'
      redirect_to agency_documents_path
    else
      flash[:error] = @document.errors.full_messages.to_sentence
      redirect_to edit_agency_document_path(@document)
    end
  end

  def destroy
    @document.destroy
    redirect_to agency_documents_path
  end

  def load_documents
    @all_documents = Document.agency_documents.includes(
      :document_attachment, :thumbnail
    ).where(category: @category)

    @documents = @all_documents.select do |document|
      document if current_agency.documents.agency_documents.include?(document) || document.agency_id == 0
    end

    content = render_to_string(
      partial: 'agency/documents/shared/list',
      locals: { documents: @documents }
    )

    render json: { status: 200, message: '', data: { content: content } }
  end

  def load_my_documents
    @my_documents = current_agency.documents.agency_documents.includes(
      :document_attachment, :thumbnail
    )
    content = render_to_string(
      partial: 'agency/documents/shared/my_list',
      locals: { my_documents: @my_documents }
    )

    render json: { status: 200, message: '', data: { content: content } }
  end

  private

  def search_query
    return '' if params[:title].blank?

    "(lower(documents.title) ILIKE '%#{params[:title]}%')"
  end

  def set_category
    @category = params[:category].presence || Document.agency_documents.categories.keys.first
  end

  def document_params
    params.require(:document).permit(
      :agency_id, :title, :description, :category, :document_link,
      document_attachment_attributes: [:id, :file, :document_id]
    )
  end

  def set_document
    @document = Document.find(params[:id])
  end

  def perform_authorization
    authorize current_agency, :documents?
  end
end
