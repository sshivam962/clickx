# frozen_string_literal: true

class ReviewsController < ActionController::Base
  layout 'review'

  after_action :allow_iframe, only: %i[new create]

  def new
    @business = Business.friendly.find(params[:business_id])
    @location = Location.friendly.find(params[:id])
    if @business.locations.include? @location
      @review = @location.reviews.new
    else
      head :ok
    end
  end

  def create
    @review = Review.new(review_params)
    @business = @review.business
    if @review.save
      @location = @review.location
      @social_links = @location.social_links
      @fb = @social_links.where(link_type: 'Facebook').first
      @yahoo = @social_links.where(link_type: 'Yahoo').first
      @g_plus_local = @social_links.where(link_type: 'Google+ Local Page').first

      if @review.rating > 3
        render 'positive_response'
      else
        render 'negative_response'
      end
    else
      render :new
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @dir = @review.directory
    if @dir == 'clickx'
      @location = @review.location
      @review.destroy
      render json: { status: 200, data: @location.reviews.directory(@dir) }
    else
      render json: { status: 400, errors: 'Cannot delete this review' }
    end
  end

  def send_mail
    @review = Review.find(params[:id])
    ReviewMailer.send_mail_to_reviewer(@review, current_user
    ).deliver_now
    render json: { status: 200, message: 'Email send successfully' }
  end

  def send_mail_with_id
    @email = params[:email]
    ReviewMailer.send_mail_to_id(
      @email, current_user, current_business.id, params[:location_id]
    ).deliver_now
    render json: { status: 200, message: 'Email send successfully' }
  end

  private

  def review_params
    params.require(:review).permit(:rating, :text, :email, :location_id, :phone_number, :directory, :name)
  end

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end
end
