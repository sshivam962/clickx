class SuperAdmin::ValueHooksController < SuperAdmin::BaseController
  before_action :set_value_hook, only: %i[edit update destroy show]

  def index
    @value_hooks = ValueHook.all
  end

  def new
    @value_hook = ValueHook.new
    @value_hook.build_thumbnail
  end

  def create
    @value_hook  = ValueHook.new(value_hook_params)
    if @value_hook.save
      flash[:success] = 'Value Hook created Successfully'
      redirect_to super_admin_value_hooks_path
    else
      flash[:error] = @value_hook.errors.full_messages.to_sentence
      @value_hook.build_thumbnail
      render :new
    end
  end

  def edit
    @value_hook.thumbnail || @value_hook.build_thumbnail
  end

  def update
    if @value_hook.update(value_hook_params)
      flash[:success] = 'Value Hook updated Successfully'
      redirect_to super_admin_value_hooks_path
    else
      flash[:error] = @value_hook.errors.full_messages.to_sentence
      @value_hook.build_thumbnail
      render :edit
    end
  end

  def destroy
    @value_hook.destroy
    redirect_to super_admin_social_posts_path
  end

  def show
  end  

  private

  def value_hook_params
    params.require(:value_hook)
          .permit(:title, :internal_title, :video_embed_code, 
                  thumbnail_attributes: [:id, :file, :_destroy])
  end

  def set_value_hook
    @value_hook  = ValueHook.find(params[:id])
  end
  
end  