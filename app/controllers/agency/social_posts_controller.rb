# frozen_string_literal: true

class Agency::SocialPostsController < Agency::BaseController
  before_action :set_social_media_ads, only: %i[show]

  def index
    @social_media_ads =
      FacebookAd.includes(:thumbnail)
                .social_media_ads
                .order(created_at: :asc)
                .first(posts_limit)
                .reverse
  end

  def show; end

  private

  def set_social_media_ads
    @social_media_ad ||= FacebookAd.find_by(id: params[:id])
  end

  def posts_limit
    (((Time.current - current_agency.created_at).to_i / 1.day)/30 * 30) + 30
  end
end
