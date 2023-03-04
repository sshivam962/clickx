class SuperAdmin::FacebookAdsController < SuperAdmin::BaseController
  layout :resolve_layout
  before_action :set_facebook_ad, only: %i[edit update destroy preview show]

  def index
    @facebook_ads = FacebookAd.facebook_ads
  end

  def new
    @facebook_ad = FacebookAd.new
    @facebook_ad.build_thumbnail
  end

  def create
    @facebook_ad  = FacebookAd.new(facebook_ad_params)
    if @facebook_ad.save
      flash[:success] = 'Facebook Ad updated Successfully'
      redirect_to super_admin_facebook_ads_path
    else
      flash[:error] = @facebook_ad.errors.full_messages.to_sentence
      @facebook_ad.build_thumbnail
      render :new
    end
  end

  def edit
    @facebook_ad.thumbnail || @facebook_ad.build_thumbnail
  end

  def update
    if @facebook_ad.update(facebook_ad_params)
      flash[:success] = 'Facebook Ad updated Successfully'
      redirect_to super_admin_facebook_ads_path
    else
      flash[:error] = @facebook_ad.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @facebook_ad.destroy
    redirect_to super_admin_facebook_ads_path
  end

  def preview
    @agency = Agency.find_by(name: 'OneIMS')
    render 'public/facebook_ads/show'
  end

  def show
    @agency = Agency.find_by(name: 'OneIMS')
  end  

  private

  def facebook_ad_params
    params.require(:facebook_ad)
          .permit(
            :title, :description, :category_type,
            images_attributes: [:id, :file, :_destroy, :heading],
            thumbnail_attributes: [:id, :file, :_destroy]
          )
  end

  def set_facebook_ad
    @facebook_ad  = FacebookAd.find(params[:id])
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