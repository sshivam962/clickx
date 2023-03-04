class SuperAdmin::SocialMediaPromptsController < SuperAdmin::BaseController
  before_action :set_social_media_prompt, only: %i[edit update destroy view]
  before_action :set_social_media_prompt_clone, only: :new

  def index
    @social_media_prompts = SocialMediaPrompt.all
  end

  def new
    @social_media_prompt ||= SocialMediaPrompt.new
  end

  def create
    @social_media_prompt = SocialMediaPrompt.new(social_media_prompt_params)

    if @social_media_prompt.save
      flash[:success] = 'Social Media Prompt Created'
      redirect_to super_admin_social_media_prompts_path
    else
      flash[:notice] = @social_media_prompt.errors.full_messages.to_sentence
      render 'new'
    end
  end

  def destroy
    @social_media_prompt.destroy
    redirect_to super_admin_social_media_prompts_path
  end

  def view; end

  def create_ai_prompt
    @gpt_prompt = ''

    @gpt_prompt << params[:prompt]
    

    client = Openai.authorization_uri
    response = client.completions(
      parameters: {
        model: "text-davinci-003",
        prompt: @gpt_prompt,
        max_tokens: 1000
    })

    content = []
    if response["choices"].present?
      content = response["choices"].map { |c| c["text"] }
    end
    render json: { status: 200, data: { content: content.to_json } }
  end

  def edit; end

  def update
    if @social_media_prompt.update(social_media_prompt_params)
      flash[:success] = 'Social Media Prompt Updated'
      redirect_to super_admin_social_media_prompts_path
    else
      flash[:notice] = @social_media_prompt.errors.full_messages.to_sentence
      render 'edit'
    end
  end

  private

  def set_social_media_prompt
    @social_media_prompt = SocialMediaPrompt.find(params[:id])
  end

  def social_media_prompt_params
    params.require(:social_media_prompt).permit(
      :title, :prompt
    )
  end

  def set_social_media_prompt_clone
    @social_media_prompt = SocialMediaPrompt.find_by(id: params[:copy_from])
    return if @social_media_prompt.blank?

    @social_media_prompt.title = "#{@social_media_prompt.title} Copy"
  end

end
