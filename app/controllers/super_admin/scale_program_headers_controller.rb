class SuperAdmin::ScaleProgramHeadersController < SuperAdmin::BaseController
  before_action :current_scale_program_header, only: [:update, :destroy]
  layout 'base'

  def index
    @scale_program_headers = ScaleProgramHeader.order(:week)
    next_week = ScaleProgramHeader.maximum(:week)
    next_week =
      next_week ? next_week + 1 : 0 
    @scale_program_header = ScaleProgramHeader.new(week: next_week)
  end

  def create
    @scale_program_header = ScaleProgramHeader.new(scale_program_header_params)
    if @scale_program_header.save 
      redirect_to super_admin_scale_program_headers_path
      flash[:notice] = 'Successfully saved'
    else
      flash[:error] = @scale_program_header.errors.full_messages.join(', ')
      redirect_to super_admin_scale_program_headers_path
    end
  end

  def update
    @scale_program_header.update(scale_program_header_params)
    redirect_to super_admin_scale_program_headers_path
    flash[:notice] = "Successfully Updated"
  end

  def destroy
    @scale_program_header.destroy
    redirect_to super_admin_scale_program_headers_path
    flash[:notice] = "Successfully deleted"
  end

  private

  def scale_program_header_params
    params.require(:scale_program_header).permit(:name, :week)
  end

  def current_scale_program_header
    @scale_program_header = ScaleProgramHeader.find(params[:id])
  end
end  