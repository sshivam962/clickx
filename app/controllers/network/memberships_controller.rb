# frozen_string_literal: true
class Network::MembershipsController < Network::BaseController
  def index
    @membership = current_user.network_membership
  end

  def update
    @membership = current_user.network_membership

    if @membership.update(memberships_params)
      render json: { percent: @membership.progress_percent }
    end
  end

  private

  def memberships_params
    params.require(:membership).permit(
      :community_joined, :publish_blog, :fb_profile_add, :social_links_add,
      :post_about_network, :personal_social_links_add, :linkedin_add,
      :network_profile_id
    )
  end
end
