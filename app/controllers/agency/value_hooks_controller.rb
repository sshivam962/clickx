class Agency::ValueHooksController < Agency::BaseController
  before_action :set_value_hooks, only: %i[edit update destroy show]

  def index
    @value_hooks = ValueHook.includes(:thumbnail).where(agency_id: current_agency.id)
  end

  def new
    @value_hook = ValueHook.new
    @value_hook.build_thumbnail
  end

  def create
    @value_hook  = ValueHook.new(value_hook_params)
    if @value_hook.save
      flash[:success] = 'Value Hook created Successfully'
      redirect_to agency_value_hooks_path
    else
      flash[:error] = @value_hook.errors.full_messages.to_sentence
      @value_hook.build_thumbnail
      render :new
    end
  end

  def show; end

  def edit
    @value_hook.thumbnail || @value_hook.build_thumbnail
  end

  def update
    if @value_hook.update(value_hook_params)
      flash[:success] = 'Value Hook updated Successfully'
      redirect_to agency_value_hooks_path
    else
      flash[:error] = @value_hook.errors.full_messages.to_sentence
      @value_hook.build_thumbnail
      render :edit
    end
  end

  def destroy
    @value_hook.destroy
    redirect_to agency_value_hooks_path
  end

  private

  def set_value_hooks
    @value_hook ||= ValueHook.find_by_id(params[:id])
  end

  def value_hook_params
    params.require(:value_hook)
          .permit(:title, :internal_title, :video_embed_code, :agency_id,
                  thumbnail_attributes: [:id, :file, :_destroy])
  end
end