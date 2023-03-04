class SuperAdmin::OutscrapperController < ApplicationController
  layout 'base'

  def index
    @all_outscrapper_data = Outscrapper::Data.paginate(page: params[:page], per_page: 10)
    @outscrapper_requests = Outscrapper::Request.paginate(page: params[:page], per_page: 10)
    if params[:agency]
      @outscrapper_requests = @outscrapper_requests.joins(:agency).where('LOWER(agencies.name) like ?', params[:agency].downcase+'%')
    end
  end

  def show
    outscrapper_data = Outscrapper::Data.find_by(id: params[:id])
    @cleaned_data = outscrapper_data.cleaned_json.paginate(page: params[:page], per_page: 25)
  end
  
  def categories
    @categories =  Outscrapper::Category.order('category ASC')
  end

  def create_categories
    category = Outscrapper::Category.new(category: params[:category])
    if category.save!
      flash[:success] = "Category Created"
    else
      flash[:error] = "Unable to create Category"
    end
  end

  def destroy_category
    category = Outscrapper::Category.find_by(id: params[:category_id])
    if category.destroy
      flash[:warning] = "Category Deleted"
    else
      flash[:error] = "Unable to delete Category"
    end
  end

  def bulk_upload
    @agencies = Agency.includes(:users, :growth_subscriptions).references(:users).reorder(created_at: :desc)
    @bulk_data = Outscrapper::BulkData.paginate(page: params[:page], per_page: 10)
  end

  def create_bulk_upload
    agency = Agency.find_by(id: params[:bulk_upload][:agency])
    # -------create lead source------------
    unless agency.nil?
      @message = [true]
      @lead_sources = agency.lead_sources.order_by_name
      return flash[:error] = @message unless @message[0]
      @lead_source = agency.lead_sources.create!(lead_source_params)
      if @lead_source.persisted?
        flash[:success] = "Lead Source created successfully and uploading data"
      else
         flash[:error] = @lead_source.errors.full_messages.to_sentence
      end
    end

    # ---------------upload data------------------
    create_lead_bulk_data(@lead_source, params[:bulk_upload][:file])
    redirect_to bulk_upload_super_admin_external_leads_path
  end

  def copy_data
    lead_source_id = params[:list_id]
    outscrapper_data = Outscrapper::Data.find_by(id: params[:data_id])
    ImportOutscrapperDataJob.perform_async(lead_source_id, outscrapper_data.cleaned_json)

    render js: "window.location.reload();", notice: "Data will be copied shortly"
  end

  def list_name
    @agency = Agency.find_by(id: params[:copy_data][:agency_id])
  end

  def create_lead_bulk_data(lead_source, file)
    lead_source_file = lead_source.lead_source_files.create(filename: file) if lead_source.present?
    status = case file.content_type
             when 'text/csv'
               # Leads from CSV File
               ImportDirectLeadsFromCsv.import(
                 lead_source.id, lead_source_file.filename.url, true
               )
             when 'application/json'
               # Leads from JSON File
               ImportDirectLeadsFromJson.import(
                 lead_source.id, lead_source_file.filename.url
               )
             when 'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
               # Leads from EXCEL File
               ImportDirectLeadsFromExcel.import(
                 lead_source.id, lead_source_file.filename.url
               )
             else
               false
             end
    if status
      flash[:success] = 'Leads Imported'
    else
      flash[:error] = 'The file format is invalid'
    end
  end

  private

  def lead_source_params
    params.require(:bulk_upload)
                          .permit(:name, :from_email_name)
  end
end
