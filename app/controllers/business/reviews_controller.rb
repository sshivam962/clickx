class Business::ReviewsController < Business::BaseController
  def index
    @locations = current_business.locations.includes(:social_links, :business)
    @locations.each do |loc|
      begin
        avg = loc.reviews.sum(:rating) / loc.reviews.where('rating > 0').count
        avg = avg.nan? ? 0.0 : avg
      rescue ZeroDivisionError
        avg = 0.0
      end
      loc.update_attributes(average_rating: avg)
    end
    @locations
  end

  def destroy
    @review = Review.find(params[:id])
    @dir = @review.directory
    if @dir == 'clickx'
      @location = @review.location
      @review.destroy
      redirect_to reviews_business_location_reviews_path
      # render json: { status: 200, data: @location.reviews.directory(@dir) }
    else
      render json: { status: 400, errors: 'Cannot delete this review' }
    end
  end
end
