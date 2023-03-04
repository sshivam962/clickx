class SuperAdmin::AdminDocumentsController < ApplicationController
  layout 'base'
  before_action :perform_authorization
  before_action :set_document, only: %i[edit update destroy]

  def index
    @documents = Document.admin_documents.includes(:document_attachment, :thumbnail)
                         .where(search_query)
                         .order(:title)
                         .paginate(page: params[:page], per_page: 20)
  end

  def new
    @document = Document.new
    @document.build_thumbnail
    @document.build_document_attachment
  end

  def create
    @document = Document.new(document_params)
    if @document.save
      flash[:success] = 'Document updated Successfully'
      redirect_to super_admin_admin_documents_path
    else
      flash[:error] = @document.errors.full_messages.to_sentence
      redirect_to new_super_admin_admin_document_path(@document)
    end
  end

  def edit; end

  def update
    if @document.update(document_params)
      flash[:success] = 'Document updated Successfully'
      redirect_to super_admin_admin_documents_path
    else
      flash[:error] = @document.errors.full_messages.to_sentence
      redirect_to edit_super_admin_admin_document_path(@document)
    end
  end

  def destroy
    @document.destroy
    redirect_to super_admin_admin_documents_path
  end

  private

  def document_params
    params.require(:document).permit(
      :title, :description, :category, :document_link, :is_admin_type,
      thumbnail_attributes: [:id, :file, :_destroy],
      document_attachment_attributes: [:id, :file, :document_id]
    )
  end

  def set_document
    @document = Document.find(params[:id])
  end

  def perform_authorization
    authorize %i[super_admin document]
  end

  def search_query
    return '' if params[:title].blank?

    "(lower(documents.title) ILIKE '%#{params[:title]}%')"
  end
end
 