class SuperAdmin::SocialPostsController < SuperAdmin::BaseController
  layout :resolve_layout
  before_action :set_social_media_ad, only: %i[edit update destroy preview show]

  def index
    @social_media_ads = FacebookAd.social_media_ads
  end

  def new
    @social_media_ad = FacebookAd.new
    @social_media_ad.build_thumbnail
  end

  def create
    @social_media_ad  = FacebookAd.new(social_media_ad_params)
    if @social_media_ad.save
      flash[:success] = 'Social Posts updated Successfully'
      redirect_to super_admin_social_posts_path
    else
      flash[:error] = @social_media_ad.errors.full_messages.to_sentence
      @social_media_ad.build_thumbnail
      render :new
    end
  end

  def edit
    @social_media_ad.thumbnail || @social_media_ad.build_thumbnail
  end

  def update
    if @social_media_ad.update(social_media_ad_params)
      flash[:success] = 'Social Post updated Successfully'
      redirect_to super_admin_social_posts_path
    else
      flash[:error] = @social_media_ad.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @social_media_ad.destroy
    redirect_to super_admin_social_posts_path
  end

  def preview
    @agency = Agency.find_by(name: 'OneIMS')
    render 'public/social_media_ads/show'
  end

  def show
    @agency = Agency.find_by(name: 'OneIMS')
  end  

  private

  def social_media_ad_params
    params.require(:facebook_ad)
          .permit(
            :title, :description, :category_type,
            images_attributes: [:id, :file, :_destroy, :heading],
            thumbnail_attributes: [:id, :file, :_destroy]
          )
  end

  def set_social_media_ad
    @social_media_ad  = FacebookAd.find(params[:id])
  end

  def resolve_layout
    case action_name
    when 'preview'
      'plain'
    else
      'base'
    end
  end
  
end  