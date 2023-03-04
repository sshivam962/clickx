# # frozen_string_literal: true

# class ReferralsController < ApplicationController
#   before_action :set_referral, only: :update

#   def index
#     referrals = Referral.all.as_json
#     data =
#       referrals.each do |referral|
#         referral['referrer'] = User.find_by(id: referral['referrer_id']).name
#         referral['referree'] = User.find_by(id: referral['referee_id']).name
#       end
#     data = sort(data)
#     total_pages = (data.count / 10).ceil
#     data = data.paginate(page: params[:page], per_page: 10)
#     render json: { data: data, total_pages: total_pages }, status: :ok
#   end

#   def update
#     @referral.update(referral_params)
#     head :ok
#   end

#   def analytics
#     data = ReferralSignup::Analytics.new.fetch
#     total_pages = (data.count / 15).ceil
#     data = sort(data)
#     data = data.paginate(page: params[:page], per_page: 15)
#     render json: { data: data, total_pages: total_pages }, status: :ok
#   end

#   private

#   def set_referral
#     @referral = Referral.find(params[:id])
#   end

#   def sort(data)
#     sort_param = params[:sort_by]
#     data = data.sort_by { |d| d[sort_param] }
#     data.reverse! if params[:sort_order] === 'false'
#     data
#   end

#   def referral_params
#     params.require(:referral_params)
#           .permit(:eligibility, :rewarded, :notes)
#   end
# end
