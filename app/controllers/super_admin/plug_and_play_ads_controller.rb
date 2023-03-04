class SuperAdmin::PlugAndPlayAdsController < SuperAdmin::BaseController
  layout :resolve_layout
  before_action :set_plug_and_play_ad, only: %i[edit update destroy preview show]

  def index
    @plug_and_play_ads = FacebookAd.plug_and_play_ads
  end

  def new
    @plug_and_play_ad = FacebookAd.new
    @plug_and_play_ad.build_thumbnail
  end

  def create
    @plug_and_play_ad  = FacebookAd.new(plug_and_play_ad_params)
    if @plug_and_play_ad.save
      flash[:success] = 'Facebook Ad updated Successfully'
      redirect_to super_admin_plug_and_play_ads_path
    else
      flash[:error] = @plug_and_play_ad.errors.full_messages.to_sentence
      @plug_and_play_ad.build_thumbnail
      render :new
    end
  end

  def edit
    @plug_and_play_ad.thumbnail || @plug_and_play_ad.build_thumbnail
  end

  def update
    if @plug_and_play_ad.update(plug_and_play_ad_params)
      flash[:success] = 'Facebook Ad updated Successfully'
      redirect_to super_admin_plug_and_play_ads_path
    else
      flash[:error] = @plug_and_play_ad.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @plug_and_play_ad.destroy
    redirect_to super_admin_plug_and_play_ads_path
  end

  def preview
    @agency = Agency.find_by(name: 'OneIMS')
    render 'public/facebook_ads/show'
  end

  def show
    @agency = Agency.find_by(name: 'OneIMS')
  end  

  private

  def plug_and_play_ad_params
    params.require(:facebook_ad)
          .permit(
            :category_type,
            images_attributes: [:id, :file, :_destroy, :heading],
            thumbnail_attributes: [:id, :file, :_destroy]
          )
  end

  def set_plug_and_play_ad
    @plug_and_play_ad  = FacebookAd.find(params[:id])
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