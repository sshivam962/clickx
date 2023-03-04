class Business::Locations::ReviewsController < Business::BaseController
  before_action :set_location

  def index
    @reviews = @location.reviews.order_dsc
  end

  def site
    data = @location.reviews.group(:name, :directory).select('name, directory, CAST(AVG(rating) AS DECIMAL(10,2)) as rating, COUNT(*) as reviews')
    render locals: { sitewise_reviews: data, location: @location}
  end

  def ratings
    data = @location.reviews.rating(5).order_dsc
    rating = @location.reviews.sum(:rating)
    total_rating = @location.reviews.count
    @avg_rating = (rating / total_rating).round(1)

    render locals: {
      reviews: data,
      location: @location,
      reviews_star_count: get_reviews_star_count,
      reviews_count: @location.reviews_count,
      reviews_growth: get_reviews_growth,
      avg_rating: @avg_rating
    }
  end

  def reviews_with_star
    @data = @location.reviews.rating(params[:star_count].to_i).order_dsc
  end

  def dir_reviews
    render locals: {reviews: @location.reviews.directory(params[:dir]).order_dsc, location: @location}
  end

  def send_mail_with_id
    @email = params[:send_mail][:email]
    ReviewMailer.send_mail_to_id(
      @email, current_user, current_business.id, params[:location_id]
    ).deliver_now
    render json: { status: 200, message: 'Email send successfully' }
  end

  def send_mail
    @review = Review.find(params[:id])
    ReviewMailer.send_mail_to_reviewer(@review, current_user
    ).deliver_now
    render json: { status: 200, message: 'Email send successfully' }
  end

  private

  def get_reviews_star_count
    rating = { '0star' => 0, '1star' => 0, '2star' => 0,
               '3star' => 0, '4star' => 0, '5star' => 0 }

    ratings = @location.reviews.pluck :rating
    ratings.each_with_object(rating) { |key, h| h["#{key.to_i}star"] += 1 }
  end

  def get_reviews_growth
    reviews_data = if @location.update_yext_reviews?
      @location.yext_reviews_info
    else
     @location.bl_reviews_info
    end

    latest_total = @location.reviews_count || 0
    prev_total = begin
      @location.reviews.where(
        'timestamp <= ?', reviews_data['count_prev_updated_at'].to_date
      ).count
    rescue StandardError
     latest_total
    end

    growth = ((latest_total - prev_total) * 100.0) / prev_total
    growth = 0 if growth.nan? || growth.infinite?

    {
      'percent' => growth,
      'number' => (latest_total - prev_total)
    }
  end

  def set_location
    @location = Location.find(params[:location_id])
  end
end
