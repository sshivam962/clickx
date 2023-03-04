# frozen_string_literal: true

class Agency::FulfilmentCoursesController < Agency::BaseController

  def index
    @courses =
      Course.includes(:chapters, :thumbnail).non_coaching
            .fulfilment.where.not(chapters: {id: nil})
            .by_position
    @agency_active_package_name = current_agency.active_package_name
  end

end
